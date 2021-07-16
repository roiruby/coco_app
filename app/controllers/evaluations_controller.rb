class EvaluationsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @evaluation = current_user.evaluations.build(evaluation_params)
    if @evaluation.save
      flash[:success] = '評価しました。'
      @evaluation.create_notification_evaluation!(current_user)
      EvaluationMailer.evaluation_notification(current_user).deliver_now
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
  private

    def evaluation_params
      params.require(:evaluation).permit(:rating).merge(entry_id: params[:entry_id])
    end

end
