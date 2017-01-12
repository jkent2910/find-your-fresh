class AddVegetablesToShare < ActiveRecord::Migration
  def change
    add_column :shares, :vegetables, :text
  end
end
