class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :post
  
  has_many :notifications, dependent: :destroy
  
  validates :content, length: { maximum: 1000 }
  
end
