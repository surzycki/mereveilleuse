class SearchForm
  include ActiveModel::Model

  attr_accessor :address, :profession_id, :patient_type_id, :information, :user_id

  validates :address, :profession_id, :patient_type_id, :user_id, presence: true 

  def search
    @search ||= Search.new({ 
      profession_ids:     [ profession_id ], 
      patient_type_ids:   [ patient_type_id ],
      user_id:            user_id,
      information:        information, 
      address:            address,
      sent_practitioners: []
    })
  end

  def process   
    # don't have to save a search that is already present (no duplicates)
    if self.valid?
      return true if search_exists?
      search.save  
    else
      false
    end
  rescue NameError => e
    errors.add(:address, I18n.t('errors.address_parser')) && false
  rescue 
    errors[:base] << I18n.t('errors.general') && false
  end

  # ActiveModel support
  def self.name;  'SearchForm'; end
  def persisted?; false; end
  def to_key;     nil; end

  private
  def search_exists?
    # make sure we generate the md5 hash for the current attributes
    search.valid?
    # check to see if the same search is already in the database   
    previous_search = Search.find_by(md5_hash: search.md5_hash )
    @search = previous_search if previous_search
  end
end