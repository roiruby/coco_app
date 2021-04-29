class ToppagesController < ApplicationController
  def index
      @posts = Post.order(id: :desc).page(params[:page]).limit(6).includes(:destinations)
  end
end