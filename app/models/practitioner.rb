class Practitioner < ActiveRecord::Base
  after_initialize :set_uuid

  has_one   :location,    dependent: :destroy, as: :locatable

  has_many  :recommendations, dependent: :destroy
  has_many  :references, through: :recommendations, source: :user

  has_many :occupations, dependent: :destroy, autosave: true
  has_many :professions, through: :occupations

  enum status: [ :not_indexed, :indexed ]

  delegate :address, 
           :address=, 
           to: :location, prefix: false, allow_nil: true

  def fullname
    "#{firstname} #{lastname}"  
  end

  def fullname=(value)
    self.firstname = Namae.parse(value).first.given
    self.lastname  = Namae.parse(value).first.family
  end

  def add_occupation(profession)
    self.occupations.find_or_create_by(profession_id: profession)
  end

  def primary_occupation
    occupations.first
  end

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid rescue nil
  end
end
