class ToppagesController < ApplicationController
  before_action :devise_variant
  
  def index
      @posts = Post.published.order("updated_at DESC").where(cancel: nil).limit(6).includes(:destinations)
      @dead_lineposts = Post.published.order(:dead_line).where("dead_line > ?", Time.zone.now).where(cancel: nil).limit(6).includes(:destinations)
      @posts_sp = Post.published.order("updated_at DESC").where(cancel: nil).limit(20).includes(:destinations)
      @dead_lineposts_sp = Post.published.order(:dead_line).where("dead_line > ?", Time.zone.now).where(cancel: nil).limit(20).includes(:destinations)
  end
  
  private
  
  def devise_variant
      case request.user_agent
      when /iPhone/
        request.variant = :mobile
      when /android/
        request.variant = :android
      end
  end
  
end