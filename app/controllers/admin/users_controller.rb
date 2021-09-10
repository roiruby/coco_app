class Admin::UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index]
  before_action :admin_user, only: [:index]
  
  def index
    @users = User.order(id: :desc).includes([:posts, :entries]).page(params[:page]).per(50)
  end
  
  private
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
end
