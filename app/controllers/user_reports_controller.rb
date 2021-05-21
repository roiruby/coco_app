class UserReportsController < ApplicationController
    before_action :require_user_logged_in, only: [:index]
  
  def create
    @report = current_user.user_reports.build(user_report_params)
    @report.user_id = current_user.id
    if @report.save
      flash[:success] = '不適切なユーザーを報告しました。'
      redirect_to root_url
    else
      redirect_to root_url
    end
  end
  
  
  
  private
  def user_report_params
    params.require(:user_report).permit(:report, :repo_id, :user_id).merge(repo_id: params[:user_id])
  end
end
