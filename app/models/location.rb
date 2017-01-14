class Location < ActiveRecord::Base
  belongs_to :share

  VALID_DAYS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

  geocoded_by :address
  after_validation :geocode

  def address
    [street_address, city, state, zipcode, "United States"].compact.join(', ')
  end

end
