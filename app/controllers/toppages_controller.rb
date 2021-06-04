class ToppagesController < ApplicationController
  
  def index
      @posts = Post.published.order("updated_at DESC").where(cancel: nil).limit(6).includes(:destinations)
      @dead_lineposts = Post.published.order(:dead_line).where("dead_line > ?", Time.zone.now).where(cancel: nil).limit(6).includes(:destinations)
  end
end