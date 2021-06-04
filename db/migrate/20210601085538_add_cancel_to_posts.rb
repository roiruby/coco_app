class AddCancelToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :cancel, :integer
  end
end
