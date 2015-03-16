class User < ActiveRecord::Base
  before_save :normalize_name

  has_one :location, dependent: :destroy, as: :locatable

  has_many :recommendations, dependent: :destroy
  has_many :referals, through: :recommendations, source: :practitioner

  enum status: [ :unregistered, :registered ] 

  def fullname
    "#{firstname} #{lastname}"  
  end

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

  private
  def normalize_name
    self.lastname  = self.lastname.try(:downcase)
    self.firstname = self.firstname.try(:downcase)
  end
end
