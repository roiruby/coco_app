class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:edit, :update, :followings, :followers, :edit_profile, :update_profile, :index, :entries, :favorites, :report]
  before_action :correct_user,   only: [:edit, :update, :edit_profile, :update_profile, :entries, :favorites]
  before_action :admin_user, only: [:destroy, :index]
  before_action :devise_variant
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(30)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      redirect_to register_path
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      flash.now[:danger] = '更新されませんでした。必須項目の入力漏れや文字数制限、アップロード画像が5MB以下になっているかご確認ください。'
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザー退会完了"
    redirect_to users_path
  end
  
  def account_edit
    @user = User.find(params[:id])
  end

  def account_update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = 'アカウント情報を更新しました'
      UserMailer.account_edit(@user).deliver_now
      redirect_to mypage_path
    else
      flash.now[:danger] = '入力に誤りがあります、もう一度入力してください'
      render :account_edit
    end
  end
  
  def posts
    @user = current_user
    @posts = @user.posts.published.includes(:entries).order("updated_at DESC").page(params[:page]).per(20)
    counts(@user)
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page]).per(20)
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page]).per(20)
    counts(@user)
  end
  
  def favorites
    @user = User.find(params[:id])
    @favposts = @user.favposts.page(params[:page]).per(20).reverse_order
    counts(@user)
  end
  
  def entries
    @user = User.find(params[:id])
    @entries = Entry.includes(:post).where(user_id: current_user.id).where.not(posts: {user_id: current_user.id} ).order('(entries.id) DESC').page(params[:page]).per(20)
    counts(@user)
  end
  
  def report
    @user = User.find(params[:id])
    @report = @user.user_reports.build
  end
  def user_reports
    @report = UserReport.order("created_at DESC").page(params[:page]).per(50)
    @report_sp = UserReport.order("created_at DESC").page(params[:page]).per(20)
    @report_rank = User.find(UserReport.group(:repo_id).order('count(repo_id) desc').page(params[:page]).per(20).pluck(:repo_id))
  end
  
  def participateds
    @user = User.find(params[:id])
    @joins = @user.entryposts.includes(:entries).where("event_schedule < ?", Time.zone.now ).where(entries: {entry_status: "approval"} ).where(cancel: nil).order('(entries.id) DESC')
    @participateds = @joins.select do |x|
      x.entries.where(entry_status: "approval").count > 1
    end
    @participateds = Kaminari.paginate_array(@participateds).page(params[:page]).per(20)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :catchphrase, :introduce, :hobby, :sex, :age, :address, :image, :remove_image, :user_id, :agreement)
  end
  
  def correct_user
      @user = User.find(params[:id])
      unless current_user.admin?
      redirect_to(root_url) unless @user == current_user
      end
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  def devise_variant
      case request.user_agent
      when /iPhone/
        request.variant = :mobile
      when /android/
        request.variant = :android
      end
  end
  
end
