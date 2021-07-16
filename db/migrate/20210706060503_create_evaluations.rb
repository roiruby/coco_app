class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.references :user, foreign_key: true
      t.references :entry, foreign_key: true
      t.integer :rating

      t.timestamps
      t.index [:user_id, :entry_id], unique: true
    end
  end
end
