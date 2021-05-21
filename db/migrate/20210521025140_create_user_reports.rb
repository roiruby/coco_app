class CreateUserReports < ActiveRecord::Migration[5.2]
  def change
    create_table :user_reports do |t|
      t.references :user, foreign_key: true
      t.references :repo, foreign_key: { to_table: :users }
      t.integer :report, null: false, default: 0

      t.timestamps
    end
  end
end
