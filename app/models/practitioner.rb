class Practitioner < ActiveRecord::Base
  def self.find_by_fullname(value = nil) 
    firstname = Namae.parse(value).first.try(:given)  || ''
    lastname  = Namae.parse(value).first.try(:family) || ''

    find_by(firstname: firstname.downcase, lastname: lastname.downcase)
  end

  after_initialize :set_uuid
  before_save :normalize_name

  has_one   :location, dependent: :destroy, as: :locatable

  has_many  :recommendations, dependent: :destroy
  has_many  :references, through: :recommendations, source: :user

  has_many :occupations, dependent: :destroy, autosave: true
  has_many :professions, through: :occupations

  enum status: [ :not_indexed, :indexed ]

  delegate :address, 
           :address=, 
           to: :location, prefix: false, allow_nil: true

  def firstname
    _firstname = read_attribute(:firstname)
    return if _firstname.nil?

    _firstname.titleize
  end

  def lastname
    _lastname = read_attribute(:lastname)
    return if _lastname.nil?

    _lastname.titleize
  end

  def fullname
    "#{firstname} #{lastname}"  
  end

  def fullname=(value)
    self.firstname = Namae.parse(value).first.given
    self.lastname  = Namae.parse(value).first.family
  end

  def add_occupation(profession_id)
    occupation = Occupation.find_or_initialize_by(
      profession_id: profession_id, 
      practitioner_id: self.id
    )

    self.association(:occupations).add_to_target(occupation)
  end

  def primary_occupation
    occupations.first
  end

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid rescue nil
  end

  def normalize_name
    self.lastname  = self.lastname.try(:downcase)
    self.firstname = self.firstname.try(:downcase)
  end
end
