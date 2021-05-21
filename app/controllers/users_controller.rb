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
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
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
      flash.now[:danger] = '更新されませんでした'
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
      redirect_to account_edit_path
    else
      flash.now[:danger] = '入力に誤りがあります、もう一度入力してください'
      render :account_edit
    end
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
    @entryposts = @user.entryposts.page(params[:page]).per(20).reverse_order
    @users = @user.entries.includes(:post)
    counts(@user)
  end
  
  def report
    @user = User.find(params[:id])
    @report = @user.user_reports.build
  end
  def user_reports
    @report = UserReport.order("created_at DESC").page(params[:page]).per(50)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :catchphrase, :introduce, :hobby, :sex, :age, :address, :image, :remove_image, :user_id)
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
