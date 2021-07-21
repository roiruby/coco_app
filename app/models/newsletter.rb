class Newsletter < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 155 }
  validates :content, presence: true
end
