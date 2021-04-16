class PostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def index
  end

  def show
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'スケジュールを投稿しました！'
      redirect_to root_url
    else
      @posts = current_user.posts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'スケジュールの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'スケジュールを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  def edit
  end

  def update
  end
  
  private

  def post_params
    params.require(:post).permit(:title, :content, :member, :payment, :budget)
  end
  
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
  end

end
