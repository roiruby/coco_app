class EntryMailer < ApplicationMailer
  def entry_notification(user, post)
    @user = user
    @post = post
    
    mail to: post.user.email, subject: "【Cocomelo】イベントにエントリーされました。"
  end
  
  def approval_notification(user, post)
    @user = user
    @post = post
    approval = Entry.where(entry_status: 'approval').order(:updated_at).last
    
    mail to: approval.user.email, subject: "【Cocomelo】イベントメンバーに確定されました！"
  end
end
