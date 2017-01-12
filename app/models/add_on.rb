class AddOn < ActiveRecord::Base
  belongs_to :farm
  validates :item, :farm_id, presence: true
end
