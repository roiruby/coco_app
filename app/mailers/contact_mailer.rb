class ContactMailer < ApplicationMailer
  default to: 'info@cocomelo.jp'

  def received_email(contact)
    @contact = contact
    mail(subject: 'Cocomeloへのお問い合わせ') do |format|
      format.html
    end
  end
  
  def send_when_contact(contact)
    @contact = contact
    mail to:      contact.email,
         subject: '【Cocomeloへのお問い合わせありがとうございます。】'
  end
 
end