class Location < ActiveRecord::Base
  belongs_to :locatable, polymorphic: true

  enum status: [ :not_geocoded, :geocoded ]

  def address
    result = [street, postal_code, city].reject(&:blank?).join(', ').titleize
    
    result.blank? ? self.unparsed_address : result
  end

  def address=(value)
    AddressParser.new(value).tap do |parser|
      parser.set(self)
    end
  end

  def short_address
    result = [city, postal_code].reject(&:blank?).join(', ').titleize
  
    result.blank? ? self.unparsed_address : result
  end
end
