class MypageController < ApplicationController
  before_action :require_user_logged_in, only: [:index]
  before_action :correct_user, only: [:index]
  before_action :devise_variant
  
  def index
    @user = current_user
    @posts = @user.posts.order("time DESC").page(params[:page]).per(20)
    counts(@user)
  end
  
  private
  
  def correct_user
      @user = current_user
      redirect_to(root_url) unless @user == current_user
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
