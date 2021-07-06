class QuitMailer < ApplicationMailer
  
  def quit_mail(quit, user)
    @quit = quit
    @user = user
    mail to: "info@cocomelo.jp", subject: "【重要】【Cocomelo】退会申請のお知らせ"
  end
  
  def send_quit_mail(quit, user)
    @quit = quit
    @user = user
    mail to: user.email, subject: "【重要】【Cocomelo】退会申請のお知らせ"
  end
  
end
