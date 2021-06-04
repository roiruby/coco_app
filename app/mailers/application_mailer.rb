class ApplicationMailer < ActionMailer::Base
  default from: "Cocomelo【ココメロ】 <info@cocomelo.jp>",
  reply_to: "info@cocomelo.jp"
  layout 'mailer'
end
