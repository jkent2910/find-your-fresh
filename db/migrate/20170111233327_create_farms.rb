class CreateFarms < ActiveRecord::Migration
  def change
    create_table :farms do |t|
      t.string :name
      t.integer :user_id
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :description
      t.string :year_founded
      t.string :website_url
      t.string :contact_email
      t.string :contact_phone

      t.timestamps null: false
    end
  end
end
