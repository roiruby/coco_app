class Destination < ApplicationRecord
  belongs_to :post

  validates :name, length: { maximum: 50 }
  validates :area, length: { maximum: 30 }
end
