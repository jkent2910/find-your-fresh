class Location < ActiveRecord::Base
  belongs_to :share

  VALID_DAYS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
end
