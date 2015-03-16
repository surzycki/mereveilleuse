module PersonNameAttributes
  extend ActiveSupport::Concern

  included do
    before_save :normalize_name
  end

  def fullname
    "#{firstname} #{lastname}"  
  end

  def fullname=(value)
    self.firstname = Namae.parse(value).first.given
    self.lastname  = Namae.parse(value).first.family
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

  module ClassMethods
    def find_by_fullname(value = nil) 
      firstname = Namae.parse(value).first.try(:given)  || ''
      lastname  = Namae.parse(value).first.try(:family) || ''
  
      find_by(firstname: firstname.downcase, lastname: lastname.downcase)
    end
  end
end