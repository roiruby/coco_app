class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    post = Post.find(params[:post_id])
    current_user.like(post)
    FavoriteMailer.favorite_notification(current_user, post).deliver_now
    post.create_notification_like!(current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    post = Post.find(params[:post_id])
    current_user.unlike(post)
    redirect_back(fallback_location: root_path)
  end
end
