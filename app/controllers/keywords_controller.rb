class KeywordsController < ApplicationController
  before_action :devise_variant
  
  def index
    @posts = params[:tag].present? ? Post.published.tagged_with(params[:tag]) : Post.published.all
    @posts = @posts.includes(:tags).reverse_order.page(params[:page]).per(20)
    @keywords = params[:tag]
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
