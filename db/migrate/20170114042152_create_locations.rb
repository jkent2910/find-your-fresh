class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :share_id
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zipcode
      t.time :start_time
      t.time :end_time
      t.text :other_info
      t.string :day_of_week
      t.string :frequency

      t.timestamps null: false
    end
  end
end
