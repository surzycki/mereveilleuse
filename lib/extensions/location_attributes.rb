module LocationAttributes
  extend ActiveSupport::Concern

  included do
    has_one :location, dependent: :destroy, as: :locatable, autosave: true

    delegate :address,          to: :location, prefix: false, allow_nil: true
    delegate :longitude,        to: :location, prefix: false, allow_nil: true
    delegate :latitude,         to: :location, prefix: false, allow_nil: true
    delegate :unparsed_address, to: :location, prefix: false, allow_nil: true
  end

  def address=(value) 
    if self.location
      self.location.address = value
    else
      self.location = Location.new(address: value)
    end
  end

end