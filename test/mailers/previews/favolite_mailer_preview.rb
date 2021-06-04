class FavoriteMailerPreview < ActionMailer::Preview
  
  # Preview this email at http://localhost:3000/rails/mailers/favorite_mailer/favorite_notification
  def favorite_notification
    user = User.first
    plan = Plan.first
    FavoriteMailer.favorite_notification(user, plan)
  end
end