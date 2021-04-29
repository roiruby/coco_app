class AddEventscheduleToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :event_schedule, :datetime
  end
end
