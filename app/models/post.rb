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

  
  enum member: { default: 0, one: 1, two_three: 2, four_six: 3, seven_nine: 4, ten_over: 5},_suffix: true
  enum sex: { default: 0, female: 1, male: 2},_suffix: true
  enum payment: { default:0, dutch_treat: 1, my_treat: 2},_suffix: true
  enum budget: { default: 0, zero_onet: 1, onet_threet: 2, threet_fivet: 3, fivet_eightt: 4, eightt_tent: 5, tent_fifteent: 6, fifteent_twentyt: 7,
                twentyt_thrtyt: 8, thrtyt_fiftyt: 9, fiftyt_onehundredt: 10, onehundredt_over: 11},_suffix: true
                
  enum status: { draft: 0, published: 1 }
                
  scope :get_by_post, ->(post) {includes([:destinations, :tags])
  .where("posts.title like ? OR posts.content like ? OR destinations.name LIKE ? OR destinations.address LIKE ? OR tags.name LIKE ?",
  "%#{post}%", "%#{post}%", "%#{post}%", "%#{post}%", "%#{post}%").references([:destinations, :tags])}

  
end
