class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.references :user, foreign_key: true, null: false
      t.references :post, foreign_key: true, null: false
      t.integer :entry_status, default: 0, null: false

      t.timestamps
      t.index [:user_id, :post_id], unique: true
    end
  end
end
