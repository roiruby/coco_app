class AddDeadLineToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :dead_line, :datetime
  end
end
