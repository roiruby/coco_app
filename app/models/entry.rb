class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  has_many :evaluations, dependent: :destroy
  has_many :evaluation_users, through: :evaluations, source: :user, dependent: :destroy

  
  enum entry_status: { unapproval: 0, approval: 1 }
  
  def toggle_status!
    if unapproval?
      approval!
      EntryMailer.approval_notification(user, post).deliver_now
      post.create_notification_approval!(post.user)
    else
      unapproval!
    end
  end
  
  validates_uniqueness_of :post_id, scope: :user_id
end
