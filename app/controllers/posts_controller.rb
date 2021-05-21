class PostsController < ApplicationController
  before_action :require_user_logged_in, only: [:create, :edit, :update, :destroy, :entry, :member, :report]
  before_action :correct_user, only: [:edit, :update, :destroy, :entry]
  before_action :admin_user, only: [:post_reports]
  before_action :set_post_tags_to_gon, only: [:edit]
  before_action :set_available_tags_to_gon, only: [:new, :edit, :create, :update]
  
  def index
    @posts = Post.published.all.reverse_order.page(params[:page]).per(20).includes(:tags)
  end

  def show
    @post = Post.find(params[:id])
    @posts = Post.published.order("updated_at DESC").limit(5).where.not(id: @post.id)
    @destinations = @post.destinations
    @user = @post.user
    @comments = @post.comments.includes(:user).all.limit(4).order(created_at: :desc)
    @comment = @post.comments.build
    @users = @post.entries.approval.includes(:user)
    comment_counts(@post)
    
    if @post.draft?
      draftplan
    end
    
  end
  
  def new
    @post = current_user.posts.build
    @destination = @post.destinations.build
    # @post.destinations.build
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_url
    else
      @posts = current_user.posts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'イベントの投稿に失敗しました。必須項目の入力漏れや文字数制限、アップロード画像が5MB以下になっているかご確認ください。'
      render :new
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'イベントを削除しました。'
    redirect_to mypage_path
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to post_path
    else
      flash.now[:danger] = 'イベントの更新に失敗しました。必須項目の入力漏れや文字数制限、アップロード画像が5MB以下になっているかご確認ください。'
      render :edit
    end
  end
  
  def comment
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user).all.order(created_at: :desc).page(params[:page]).per(20)
    @comment = @post.comments.build
    comment_counts(@post)
  end
  
  def confirm
    @user = current_user
    @posts = @user.posts.draft.order("updated_at DESC").page(params[:page]).per(20)
    @count_draft = @user.posts.draft.count
  end
  
  def draftplan
    redirect_to root_path unless current_user == @user
  end
  
  def entry
    @post = Post.find(params[:id])
    @users = @post.entries.includes(:user).page(params[:page]).per(20)
  end
  def member
    @post = Post.find(params[:id])
    @comments = @post.members.includes(:user).all.order(created_at: :desc).page(params[:page]).per(20)
    @comment = @post.members.build
    comment_counts(@post)
    @users = @post.entries.approval.includes(:user)
    @destinations = @post.destinations
    
    if @post.approval_users.count == 0
      unless @post.user_id == current_user.id || current_user.admin?
        redirect_to root_url
        return
      end
    else
      @approvaluser = @post.approval_users.where(id: current_user)
      if @approvaluser.count == 1
        @approvaluser.each do |user|
          if user == current_user.id
            redirect_to root_url
            return
          end
        end
      else
        unless @post.user_id == current_user.id || current_user.admin?
          redirect_to root_url
          return
        end
      end
    end
  end

  
  def search
    @post = Post.published.order("updated_at DESC")
    @search_word = params[:search]
    
    if params[:search] == ""
      @posts = Post.published.order("updated_at DESC")
    else
      searches = params[:search].split(/[[:blank:]]+/).select(&:present?)
      @posts = Post
      searches.each do |search|
      @posts = @posts.includes([:destinations, :category, :tags])
      .where(['posts.title LIKE ? OR posts.content LIKE ? OR destinations.name LIKE ? OR destinations.address LIKE ? OR categories.name LIKE ? OR tags.name LIKE ?',
      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"]).references([:destinations, :category, :tags])
      end
    end
    @posts = @posts.published.order(updated_at: "DESC").page(params[:page]).per(20)
  end
  
  def report
    @post = Post.find(params[:id])
    @report = @post.post_reports.build
  end
  def post_reports
    @report = PostReport.order("created_at DESC").page(params[:page]).per(50)
  end
  
  
  private

  def post_params
    params.require(:post).permit(:title, :content, :member, :payment, :budget, :sex, :image, :remove_image, :category_id, :event_schedule, :tag_list, :status, :dead_line, 
    destinations_attributes: [:id, :name, :_destroy, :link, :area, :address])
  end
  
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
    unless current_user.admin? #
      redirect_to root_url
    end
    end
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  def set_post_tags_to_gon
    @post = Post.find_by(id: params[:id]) #
    gon.post_tags = @post.tag_list
  end
  
  def set_available_tags_to_gon
    gon.available_tags = Post.tags_on(:tags).pluck(:name)
  end

end
