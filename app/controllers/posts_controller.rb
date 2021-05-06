class PostsController < ApplicationController
  before_action :require_user_logged_in, only: [:create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_post_tags_to_gon, only: [:edit]
  before_action :set_available_tags_to_gon, only: [:new, :edit, :create, :update]
  
  def index
    @posts = Post.all.reverse_order.page(params[:page]).per(20).includes(:tags)
  end

  def show
    @post = Post.find(params[:id])
    @destinations = @post.destinations
    @user = @post.user
  end
  
  def new
    @post = current_user.posts.build
    @destination = @post.destinations.build
    # @post.destinations.build
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'イベントを投稿しました！'
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
  
  private

  def post_params
    params.require(:post).permit(:title, :content, :member, :payment, :budget, :sex, :image, :remove_image, :category_id, :event_schedule, :tag_list, :dead_line, 
    destinations_attributes: [:id, :name, :_destroy, :link, :area, :address])
  end
  
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
  end
  
  def set_post_tags_to_gon
    @post = Post.find_by(id: params[:id]) #
    gon.post_tags = @post.tag_list
  end
  
  def set_available_tags_to_gon
    gon.available_tags = Post.tags_on(:tags).pluck(:name)
  end

end
