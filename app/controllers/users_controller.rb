class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:edit, :update, :followings, :followers, :edit_profile, :update_profile, :index]
  before_action :correct_user,   only: [:edit, :update, :edit_profile, :update_profile]
  
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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :catchphrase, :introduce, :hobby, :sex, :age, :address, :image, :remove_image, :user_id)
  end
  
  def correct_user
      @user = User.find(params[:id])
  end
  
end
