class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :farm_id
      t.string :season
      t.date :start_date
      t.date :end_date
      t.integer :weeks
      t.integer :price
      t.text :description
      t.integer :num_shares
      t.boolean :organic
      t.boolean :taking_orders

      t.timestamps null: false
    end
  end
end
