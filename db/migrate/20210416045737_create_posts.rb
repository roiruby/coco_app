class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :member, null: false, default: 0
      t.integer :payment, null: false, default: 0
      t.integer :budget, null: false, default: 0
      t.integer :sex, null: false, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
