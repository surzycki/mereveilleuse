class Location < ActiveRecord::Base
  belongs_to :locatable, polymorphic: true

  def address
    [street, postal_code, city].reject(&:blank?).join(', ').titleize
  end

  def address=(value)
    
  end

  def short_address
    [city, postal_code].reject(&:blank?).join(', ').titleize
  end
end
