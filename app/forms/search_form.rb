class SearchForm
  include ActiveModel::Model

  attr_reader   :search, :location
  attr_accessor :address, :profession_id, :patient_id, :information, :user_id

  def location
    @location ||= Location.new(address: @address)
  end

  def search
    @search ||= Search.new({ 
      profession_ids: [ @profession_id ], 
      patient_ids:    [ @patient_id ],
      user_id:        @user_id,
      information:    @information, 
      location:       location
    })
  end

  def save    
    if(search_exists? or search.valid?)
      publish :success, self
    else
      publish :error, self
    end
  end

  # ActiveModel support
  def self.name;  'SearchForm'; end
  def persisted?; false; end
  def to_key;     nil; end

  private
  def search_exists?
    Search.where(hash_id: search.hash_id )
  end
end