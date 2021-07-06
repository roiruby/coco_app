class CancelMailer < ApplicationMailer
  def cancel_notification(user, post)
    @user = user
    @post = post
    @entry_users = post.entries.includes(:user)
    
    mail bcc: @entry_users.pluck(:email), subject: "【Cocomelo】イベントがキャンセルされました。"
  end
  
  def send_cancel_notification(user, post)
    @user = user
    @post = post
    
    mail to: user.email, subject: "【Cocomelo】イベントをキャンセルしました。"
  end
end
