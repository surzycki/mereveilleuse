class Recommendation < ActiveRecord::Base
  has_and_belongs_to_many :patient_types
  
  belongs_to :user
  belongs_to :practitioner
end
