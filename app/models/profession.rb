class Profession < ActiveRecord::Base
  has_many :occupations
  has_many :practitioners, through: :occupations
end
