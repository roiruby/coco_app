class Post < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 155 }
  validates :content, presence: true, length: { maximum: 7777 }
  validates :member, length: { maximum: 55 }
  validates :budget, length: { maximum: 55 }
  
end
