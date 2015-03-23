class Recommendation < ActiveRecord::Base
  has_and_belongs_to_many :patient_types
  
  belongs_to :user
  belongs_to :practitioner, autosave: true
  belongs_to :profession

  searchkick locations: ['coordinates'], index_prefix: Rails.env

  def latitude 
    Monad::Maybe(practitioner).latitude.to_f
  end

  def longitude 
    Monad::Maybe(practitioner).longitude.to_f
  end

  def coordinates
    [ latitude, longitude ]
  end

  def rating
    %w(wait_time availability bedside_manner efficacy).map do |attr|
      self.send(attr.to_sym)
    end.instance_eval { reduce(:+) / size.to_f }
  end

  def search_data
    { 
      coordinates:      coordinates,
      profession_id:    self.profession_id,
      patient_type_ids: patient_types.map(&:id)
    }
  end

  def should_index?
    state == 'completed'
  end
end
