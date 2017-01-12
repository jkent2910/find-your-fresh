class Farm < ActiveRecord::Base
  belongs_to :user

  validates :name, :user_id, presence: true

  has_many :farm_photos, :dependent => :destroy

  has_many :shares, :dependent => :destroy
  accepts_nested_attributes_for :shares, reject_if: :all_blank, allow_destroy: true

  has_many :add_ons, :dependent => :destroy
  accepts_nested_attributes_for :add_ons, reject_if: :all_blank, allow_destroy: true

end
