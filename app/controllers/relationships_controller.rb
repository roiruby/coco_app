class RelationshipsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    user = User.find(params[:follow_id])
    current_user.follow(user)
    user.create_notification_follow!(current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    user = User.find(params[:follow_id])
    current_user.unfollow(user)
    redirect_back(fallback_location: root_path)
  end
end
