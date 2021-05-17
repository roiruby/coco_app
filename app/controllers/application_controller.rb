class ApplicationController < ActionController::Base
  
  include SessionsHelper

  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def counts(user)
    @count_posts = user.posts.published.count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
    @count_favposts = user.favposts.count
    @count_entryposts = user.entryposts.count
  end
  
  def comment_counts(post)
    @count_comments = post.comments.count
    @count_commentmembers = post.members.count
  end
  
end