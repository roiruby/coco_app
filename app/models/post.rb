class Post < ApplicationRecord
  belongs_to :user
  
  acts_as_taggable
  
  has_many :destinations, dependent: :destroy, inverse_of: :post
  accepts_nested_attributes_for :destinations, reject_if: :all_blank, allow_destroy: true
  
  validates :title, presence: true, length: { maximum: 155 }
  validates :content, presence: true, length: { maximum: 7777 }
  validates :event_schedule, presence: true
  validates :category, presence: true
  validates :dead_line, presence: true
  
  validate :event_cannot_be_in_the_past
  def event_cannot_be_in_the_past
    if event_schedule < Date.today
      errors.add(:event_schedule, ": 過去の日付は使用できません")
    end
  end
  
  validate :dead_line_cannot_be_in_the_past
  def dead_line_cannot_be_in_the_past
    if dead_line < Date.today or event_schedule < dead_line
      errors.add(:dead_line, ": イベント日時より過去の日付は使用できません")
    end
  end

  
  mount_uploader :image, ImageUploader
  
  belongs_to :category, optional: true
  
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites, dependent: :destroy
  
  has_many :comments, dependent: :destroy
  
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries, dependent: :destroy
  has_many :approval_post_users, -> {where(entry_status: 'approval')}, class_name: 'Entry'
  has_many :approval_users, through: :approval_post_users, source: :user, dependent: :destroy
  
  has_many :members, dependent: :destroy
  
  has_many :post_reports, dependent: :destroy
  
  has_many :notifications, dependent: :destroy

  
  enum member: { default: 0, one: 1, two_three: 2, four_six: 3, seven_nine: 4, ten_over: 5},_suffix: true
  enum sex: { default: 0, female: 1, male: 2},_suffix: true
  enum payment: { default:0, dutch_treat: 1, my_treat: 2},_suffix: true
  enum budget: { default: 0, zero_onet: 1, onet_threet: 2, threet_fivet: 3, fivet_eightt: 4, eightt_tent: 5, tent_fifteent: 6, fifteent_twentyt: 7,
                twentyt_thrtyt: 8, thrtyt_fiftyt: 9, fiftyt_onehundredt: 10, onehundredt_over: 11},_suffix: true
                
  enum status: { draft: 0, published: 1 }
  
  enum cancel: { default: 0, member: 1, schedule: 2, reservation: 3, entry_user: 4, other: 5,},_suffix: true
                
  # scope :get_by_post, ->(post) {includes([:destinations, :tags])
  # .where("posts.title like ? OR posts.content like ? OR destinations.name LIKE ? OR destinations.address LIKE ? OR tags.name LIKE ?",
  # "%#{post}%", "%#{post}%", "%#{post}%", "%#{post}%", "%#{post}%").references([:destinations, :tags])}
  

  def create_notification_like!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])

    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )

      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  
  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )

    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
  
  def create_notification_talkroom!(current_user, member_id)
    temp_ids = Member.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_talkroom!(current_user, member_id, temp_id['user_id'])
    end
    save_notification_talkroom!(current_user, member_id, user_id) if temp_ids.blank?
  end

  def save_notification_talkroom!(current_user, member_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: member_id,
      visited_id: visited_id,
      action: 'talkroom'
    )

    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
  
  def create_notification_post!(current_user, post_id)
    current_user.follower_ids.each do |followers|
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, followers, id, 'post'])
    
    if temp.blank?
        notification = current_user.active_notifications.new(
          post_id: id,
          visited_id: followers,
          action: 'post'
        )
  
        if notification.visitor_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
    end
    end
  end
  
  def create_notification_entry!(current_user)
    notification = current_user.active_notifications.new(
      post_id: id,
      visited_id: user_id,
      action: 'entry'
    )
      notification.save if notification.valid?
  end
  
  def create_notification_cancel!(current_user, post_id)
    entry_users = self.entries.includes(:user)
    entry_users.each do |entry_user|
    notification = current_user.active_notifications.new(
      post_id: id,
      visited_id: entry_user.user_id,
      action: 'cancel'
    )
      notification.save if notification.valid?
    end
  end
  
  def create_notification_approval!(current_user)
    app_users = self.approval_users
    app_users.each do |app_user|
    temp = Notification.where(visitor_id: user_id, visited_id: app_user.id, post_id: id, action: 'approval')
    
      if temp.blank?
      notification = current_user.active_notifications.new(
        visitor_id: user_id,
        post_id: id,
        visited_id: app_user.id,
        action: 'approval'
      )
        notification.save if notification.valid?
      end
    end
  end

  
end
