class Practitioner < ActiveRecord::Base
  include PersonNameAttributes

  after_initialize :set_uuid

  has_one   :location, dependent: :destroy, as: :locatable

  has_many  :recommendations, dependent: :destroy
  has_many  :references, through: :recommendations, source: :user

  has_many :occupations, dependent: :destroy, autosave: true
  has_many :professions, through: :occupations

  enum status: [ :not_indexed, :indexed ]

  # For activeadmin new_record? nil issue
  # http://stackoverflow.com/questions/7206541/activeadmin-with-has-many-problem-undefined-method-new-record
  accepts_nested_attributes_for :occupations, allow_destroy: true

  delegate :address, 
           :address=, 
           to: :location, prefix: false, allow_nil: true

  searchkick word_start: [:fullname], index_prefix: Rails.env

  def add_occupation(profession_id)
    occupation = Occupation.find_or_initialize_by(
      profession_id: profession_id, 
      practitioner_id: self.id
    )

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

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid rescue nil
  end
end
