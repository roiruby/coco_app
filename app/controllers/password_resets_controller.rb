class PasswordResetsController < ApplicationController
  before_action :get_user,          only: [:edit, :update]
  before_action :valid_user,        only: [:edit, :update]
  before_action :check_expiration,  only: [:edit, :update]
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to reset_path
    else
      flash.now[:danger] = "メールアドレスに誤りがあります、もう一度入力してください。"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      flash[:danger] = "パスワードの更新ができませんでした、もう一度入力してください。"
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      redirect_to @user
    else
      flash[:danger] = "パスワードの更新ができませんでした、もう一度入力してください。"
      render 'edit'
    end
  end
  
  def reset
  end
  
  private
  
  def user_params
      params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end
  
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "パスワード再設定用の認証URLの有効期限が切れました。"
      redirect_to new_password_reset_url
    end
  end
end
