class RelationshipMailer < ApplicationMailer
  def follow_notification(user, follower)
    @user = user
    @follower = follower
    mail to: user.email, subject: "【Cocomelo】フォローされました！"
  end
end
