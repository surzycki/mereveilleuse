class User < ActiveRecord::Base
  has_one :location, dependent: :destroy, as: :locatable

  has_many :recommendations, dependent: :destroy
  has_many :referals, through: :recommendations, source: :practitioner

  enum state: [ :unregistered, :registered ] 
end
