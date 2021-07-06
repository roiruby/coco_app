class MypageController < ApplicationController
  before_action :require_user_logged_in, only: [:index]
  before_action :correct_user, only: [:index]
  before_action :devise_variant
  
  def index
    @posts = current_user.feed_posts.order(id: :desc).page(params[:page]).per(20)
    @followings = @user.followings.page(params[:page]).per(20)
    
    @notifications = current_user.passive_notifications.page(params[:page]).per(20)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
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
