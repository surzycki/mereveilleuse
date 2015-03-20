class Profession < ActiveRecord::Base
  has_and_belongs_to_many :searches, join_table: 'searches_professions'

  has_many :occupations
  has_many :practitioners, through: :occupations
end
