class SearchForm
  include ActiveModel::Model

  attr_reader   :search, :location
  attr_accessor :address, :profession_id, :patient_id, :information

  def location
    @location ||= Location.new(address: @address)
  end

  def search
    @search ||= Search.new
  end

  def save
    search.location = location

  end

  # ActiveModel support
  def self.name;  'SearchForm'; end
  def persisted?; false; end
  def to_key;     nil; end

end