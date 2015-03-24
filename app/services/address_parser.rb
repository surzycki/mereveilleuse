class AddressParser
  attr_reader :street, :city, :postal_code,  :department, :region, :country, :latitude, :longitude, :status

  def initialize(address)
    begin
      
      result       = find address
      
      @street      = parse_address(result.address)
      @city        = result.city 
      @postal_code = result.postal_code
      @department  = result.try(:sub_state)
      @region      = result.state
      @country     = result.country
  
      @latitude    = result.latitude
      @longitude   = result.longitude 
      @status      = 'geocoded'

    rescue => e
      raise NameError
    end
  end

  def set(object)
    [ :city, :postal_code, :department, :region, :country, :latitude, :longitude, :status ].each do |attr|
      object.send "#{attr}=", self.send(attr)
    end

    object.street = street
  end

  private
  def find(address)
    Geocoder.search(address, region: 'fr').first
  end

  def parse_address(value)
    array = value.split(',')
    return if array.count < 3
    array.first
  end
end