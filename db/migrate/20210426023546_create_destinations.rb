class CreateDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :destinations do |t|
      t.string :name
      t.integer :post_id
      t.string :area
      t.string :link
      t.string :address

      t.timestamps
    end
  end
end
