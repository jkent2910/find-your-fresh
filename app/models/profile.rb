class Profile < ActiveRecord::Base
  belongs_to :user

  enum gender: { female: 1, male: 2 }
  has_attached_file :profile_picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "missing.png"
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\Z/

  geocoded_by :address
  after_validation :geocode

  def address
    [street_address, city, state, zipcode, "United States"].compact.join(', ')
  end
end
