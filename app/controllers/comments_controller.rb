class CommentsController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :destroy]
  
  def create
    post = Post.find(params[:post_id])
    @comment = post.comments.build(comment_params)
    @comment.user_id = current_user.id
    @post = @comment.post
    if @comment.save
       @post.create_notification_comment!(current_user, @comment.id)
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
    
end
