class Occupation < ActiveRecord::Base
  belongs_to :profession
  belongs_to :practitioner
end
