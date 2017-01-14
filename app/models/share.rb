class Share < ActiveRecord::Base
  extend SelectionHelper

  VALID_SEASONS = ['Spring', 'Summer', 'Fall', 'Winter']

  belongs_to :farm
  validates_inclusion_of :season, in: VALID_SEASONS

  has_many :locations
  accepts_nested_attributes_for :locations, reject_if: :all_blank, allow_destroy: true

  serialize :vegetables, Array
end
