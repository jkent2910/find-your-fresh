class Share < ActiveRecord::Base
  belongs_to :farm

  VALID_SEASONS = ['Spring', 'Summer', 'Fall', 'Winter']
end
