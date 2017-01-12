class ChangePriceToString < ActiveRecord::Migration
  def change
    change_column :shares, :price, :string
  end
end
