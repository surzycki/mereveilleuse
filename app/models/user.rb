class User < ActiveRecord::Base
  include PersonNameAttributes
  include LocationAttributes
  
  has_many :searches, dependent: :destroy

  has_many :recommendations, dependent: :destroy
  has_many :referals, through: :recommendations, source: :practitioner

  enum status: [ :unregistered, :registered ] 

end
