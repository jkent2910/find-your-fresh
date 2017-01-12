class CreateFarmPhotos < ActiveRecord::Migration
  def change
    create_table :farm_photos do |t|
      t.attachment :image
      t.integer :farm_id

      t.timestamps null: false
    end
  end
end
