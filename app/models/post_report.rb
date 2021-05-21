class PostReport < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  enum report: { default: 0, spam: 1, harassment: 2, annoying: 3, etc: 4},_suffix: true
end
