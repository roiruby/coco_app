class RelationshipMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/relationship_mailer/follow_notification
  def follow_notification
    user = User.first
    follower = User.second
    RelationshipMailer.follow_notification(user, follower)
  end

end