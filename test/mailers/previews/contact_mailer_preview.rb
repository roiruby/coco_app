class ContactMailerPreview < ActionMailer::Preview
  
  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/send_when_contact
  def send_when_contact
    contact = Contact.new(name: '菅田 将暉', category: 'サービスについて', email: 'suda@example.com', content: 'お友達へのプレゼント選びは、趣味や好みが分かっているので、とても楽しく探すことができますね。ただ、予算が限られているなら話は別！お値段以上に素敵な、お友達をハッピーにできるプレゼントとは...？')
    ContactMailer.send_when_contact(contact)
  end

  


end