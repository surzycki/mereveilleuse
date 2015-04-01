class Profession < ActiveRecord::Base
  has_and_belongs_to_many :searches, join_table: 'searches_professions'

  has_many :occupations
  has_many :practitioners, through: :occupations

  enum status: [ :not_indexed, :indexed ]

  searchkick word_start: [:name], index_prefix: "mereveilleuse-#{Rails.env}"

  def search_data
    { name: self.name }
  end

  def should_index?
    indexed?
  end
end
