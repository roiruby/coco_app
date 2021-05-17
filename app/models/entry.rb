class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  enum entry_status: { unapproval: 0, approval: 1 }
  
  def toggle_status!
    if unapproval?
      approval!
    else
      unapproval!
    end
  end
  
  validates_uniqueness_of :post_id, scope: :user_id
end
