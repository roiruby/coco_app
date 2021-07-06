class UserMailer < ApplicationMailer
  
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "【Cocomelo】メールアドレス確認"
  end
  
  def send_account_activation(user)
    @user = user
    mail to: user.email, subject: "【Cocomelo】登録完了のお知らせ"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "【Cocomelo】パスワード再設定のお申込み"
  end
  
  def account_edit(user)
    @user = user
    mail to: user.email, subject: "【Cocomelo】アカウント情報変更完了のお知らせ"
  end

end
