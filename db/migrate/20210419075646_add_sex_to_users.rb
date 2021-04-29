class AddSexToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sex, :integer, null: false, default: 0
  end
end
