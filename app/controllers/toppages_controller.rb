class ToppagesController < ApplicationController
  def index
      @posts = Post.published.order("updated_at DESC").limit(6).includes(:destinations)
  end
end