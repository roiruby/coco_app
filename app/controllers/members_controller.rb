class MembersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :destroy]
  
  def create
    post = Post.find(params[:post_id])
    @comment = post.members.build(member_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
  def destroy
    @comment = Member.find(params[:id])
    @comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def member_params
      params.require(:member).permit(:content)
    end
    
end
