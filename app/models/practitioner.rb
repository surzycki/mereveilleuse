class Practitioner < ActiveRecord::Base
  has_many  :occupations, dependent: :destroy, inverse_of: :practitioner, autosave: true
  
  has_many  :recommendations, dependent: :destroy
  has_many  :references, through: :recommendations, source: :user
end
