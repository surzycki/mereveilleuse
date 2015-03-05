class User < ActiveRecord::Base
  has_many :recommendations, dependent: :destroy
  has_many :referals, through: :recommendations, source: :practitioner
end
