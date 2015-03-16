class User < ActiveRecord::Base
  include PersonNameAttributes

  has_one :location, dependent: :destroy, as: :locatable

  has_many :recommendations, dependent: :destroy
  has_many :referals, through: :recommendations, source: :practitioner

  enum status: [ :unregistered, :registered ] 

end
