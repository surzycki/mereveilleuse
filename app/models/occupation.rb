class Occupation < ActiveRecord::Base
  belongs_to :practitioner, inverse_of: :occupations
end
