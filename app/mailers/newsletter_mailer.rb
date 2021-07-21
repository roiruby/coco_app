class NewsletterMailer < ApplicationMailer
  def send_newsletter(newsletter)
    @newsletter = newsletter
    mail bcc: User.pluck(:email), subject: "【Cocomelo】#{newsletter.title}"
  end
end
