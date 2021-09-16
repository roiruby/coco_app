class Evaluation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :entry, optional: true
  
  # has_many :notifications, dependent: :destroy
  
  validates :rating, presence: true
  
  enum rating: { excellent: 0, good: 1, poor: 2 }
  
  validates_uniqueness_of :entry_id, scope: :user_id
  
  def create_notification_evaluation!(current_user)
    Evaluation.includes(:entry).where(user_id: current_user.id).each do |evaluation|
    temp = Notification.where(visitor_id: current_user.id, visited_id: evaluation.entry.user.id, post_id: evaluation.entry.post.id, action: 'evaluation')
    
      if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: evaluation.entry.post.id,
        visited_id: evaluation.entry.user.id,
        action: 'evaluation'
      )
        notification.save if notification.valid?
      end
    end
  end
  
end
