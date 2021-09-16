class Member < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :post
  
  validates :content, length: { maximum: 1000 }
end
