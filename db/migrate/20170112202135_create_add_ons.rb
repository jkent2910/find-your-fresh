class CreateAddOns < ActiveRecord::Migration
  def change
    create_table :add_ons do |t|
      t.string :item
      t.string :description
      t.string :price
      t.integer :farm_id

      t.timestamps null: false
    end
  end
end
