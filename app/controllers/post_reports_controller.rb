class PostReportsController < ApplicationController
  before_action :require_user_logged_in, only: [:index]
  
  def create
    post = Post.find(params[:post_id])
    @report = post.post_reports.build(post_report_params)
    @report.user_id = current_user.id
    if @report.save
      flash[:success] = '不適切な投稿を報告しました。'
      redirect_to root_url
    else
      redirect_to root_url
    end
  end
  
  
  
  private
  def post_report_params
    params.require(:post_report).permit(:report, :post_id)
  end
end
