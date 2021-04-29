class AddAddressToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :address, :integer, null: false, default: 0
  end
end
