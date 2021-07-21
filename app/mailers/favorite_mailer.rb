class FavoriteMailer < ApplicationMailer
  def favorite_notification(user, post)
    @user = user
    @post = post
    mail to: post.user.email, subject: "【Cocomelo】お気に入りに追加されました！"
  end
end
