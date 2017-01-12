class Share < ActiveRecord::Base
  extend SelectionHelper

  VALID_SEASONS = ['Spring', 'Summer', 'Fall', 'Winter']

  belongs_to :farm
  validates_inclusion_of :season, in: VALID_SEASONS

  serialize :vegetables, Array
end
