class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :follow, class_name: 'User'
  
  def Relationship.send_follow_email(user, follower)
    RelationshipMailer.follow_notification(user, follower).deliver_now
  end
end
