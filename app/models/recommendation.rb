class Recommendation < ActiveRecord::Base
  has_and_belongs_to_many :patient_types
  
  belongs_to :user
  belongs_to :practitioner
  belongs_to :profession

  delegate :latitude,  to: :practitioner, prefix: false, allow_nil: true
  delegate :longitude, to: :practitioner, prefix: false, allow_nil: true
  delegate :address,   to: :practitioner, prefix: false, allow_nil: true

  searchkick locations: ['location'], index_prefix: Rails.env

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
      location:         coordinates,
      profession_id:    self.profession_id,
      patient_type_ids: patient_types.map(&:id),
      practitioner_id:  practitioner.id,
      rating:           self.rating
    }
  end

  def should_index?
    state == 'completed'
  end
end
