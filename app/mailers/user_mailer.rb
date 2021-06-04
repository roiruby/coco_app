class UserMailer < ApplicationMailer
  
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "【Sharingood】メールアドレス確認"
  end
  
  def send_account_activation(user)
    @user = user
    mail to: user.email, subject: "【Sharingood】登録完了のお知らせ"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "【Sharingood】パスワード再設定のお申込み"
  end
  
  def account_edit(user)
    @user = user
    mail to: user.email, subject: "【Sharingood】アカウント情報変更完了のお知らせ"
  end

end
