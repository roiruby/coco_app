class ApplicationMailer < ActionMailer::Base
  default from: "Sharingood【シェアリングッド】 <info@sharingood.jp>",
  reply_to: "info@sharingood.jp"
  layout 'mailer'
end
