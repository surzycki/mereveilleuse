class Recommendation < ActiveRecord::Base
  include Links
  
  has_and_belongs_to_many :patient_types
  
  belongs_to :recommender, class_name: :User, foreign_key: 'user_id'

  belongs_to :practitioner
  belongs_to :profession

  delegate :latitude,       to: :practitioner, prefix: false, allow_nil: true
  delegate :longitude,      to: :practitioner, prefix: false, allow_nil: true
  delegate :address,        to: :practitioner, prefix: false, allow_nil: true
  delegate :short_address,  to: :practitioner, prefix: false, allow_nil: true
  delegate :email,          to: :practitioner, prefix: false, allow_nil: true 
  delegate :contact_phone,  to: :practitioner, prefix: false, allow_nil: true 

  delegate :fullname,  to: :practitioner, prefix: true, allow_nil: true
  delegate :fullname,  to: :recommender,  prefix: true, allow_nil: true
  delegate :name,      to: :profession,   prefix: true, allow_nil: true

  searchkick locations: ['location'], index_prefix: "mereveilleuse-#{Rails.env}"

  def coordinates
    [ latitude, longitude ]
  end

  def rating
    dimensions = %w(wait_time availability bedside_manner efficacy)
    
    dividend = dimensions.map do |attr|
      self.send(attr.to_sym)
    end.instance_eval { reduce(:+) }

    (dividend.to_f * max_rating.to_f)  / (dimensions.count * dimensions.count)
  end

  def max_rating
    20
  end

  def search_data
    { 
      location:         coordinates,
      profession_id:    self.profession_id,
      patient_type_ids: patient_types.map(&:id),
      practitioner_id:  practitioner.id,
      rating:           self.rating,
      recommender_id:   recommender.id
    }
  end

  def should_index?
    recommender.present?
  end

  def patient_type_name
    Maybe(patient_types.first).name._
  end
end
