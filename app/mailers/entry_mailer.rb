class EntryMailer < ApplicationMailer
  def entry_notification(user, post)
    @user = user
    @post = post
    
    mail to: post.user.email, subject: "【Cocomelo】イベントにエントリーされました。"
  end
  
  def approval_notification(user, post)
    @user = user
    @post = post
    @users = post.entries.approval.includes(:user)
    
    mail to: @users.pluck(:email), subject: "【Cocomelo】イベントメンバーに確定されました！"
  end
end
