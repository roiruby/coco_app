class EvaluationMailer < ApplicationMailer
  def evaluation_notification(user)
    @user = user
    
    mail to: Evaluation.includes(:entry).last.entry.user.email, subject: "【Cocomelo】評価されました！"
  end
end
