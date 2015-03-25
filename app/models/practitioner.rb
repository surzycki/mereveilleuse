class Practitioner < ActiveRecord::Base
  include PersonNameAttributes
  include LocationAttributes

  after_initialize :set_uuid
  before_save      :reindex_recommendations, if: Proc.new { |practitioner| practitioner.location_changed? }

  has_many  :recommendations, dependent: :destroy
  has_many  :references, through: :recommendations, source: :user

  has_many :occupations, dependent: :destroy, autosave: true
  has_many :professions, through: :occupations

  has_and_belongs_to_many :federations
  has_and_belongs_to_many :insurances

  enum status: [ :not_indexed, :indexed ]

  # For activeadmin new_record? nil issue
  # http://stackoverflow.com/questions/7206541/activeadmin-with-has-many-problem-undefined-method-new-record
  accepts_nested_attributes_for :occupations, allow_destroy: true

  searchkick word_start: [:fullname], index_prefix: Rails.env

  def add_occupation(profession_id)
    occupation = Occupation.find_or_initialize_by(
      profession_id: profession_id, 
      practitioner_id: self.id
    )

    # dont save
    self.association(:occupations).add_to_target(occupation)
  end

  def primary_occupation
    occupations.try(:first) || NullOccupation.new
  end

  def search_data
    { 
      fullname: fullname,
      firstname: self.firstname,
      lastname: self.lastname
    }
  end

  def should_index?
    indexed?
  end

  def location_changed?
    location.try(:changed?)
  end

  def geocoded?
    Monad::Maybe(location).geocoded? == true
  end

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid rescue nil
  end

  def reindex_recommendations
    recommendations.each do |recommendation|
      recommendation.reindex
    end
  end
end
