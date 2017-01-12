class Farm < ActiveRecord::Base
  belongs_to :user

  validates :name, :user_id, presence: true

  has_many :farm_photos, :dependent => :destroy
end
