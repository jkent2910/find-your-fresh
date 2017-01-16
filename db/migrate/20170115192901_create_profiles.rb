class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zipcode
      t.float :latitude
      t.float :longitude
      t.integer :gender
      t.text :bio
      t.boolean :looking_for_split
      t.boolean :looking_for_csa
      t.attachment :profile_picture

      t.timestamps null: false
    end
  end
end
