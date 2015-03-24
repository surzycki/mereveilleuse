class RecommendationForm
  include ActiveModel::Model

  attr_accessor :user_id, :practitioner_name, :patient_type_id, :profession_id, :address, :wait_time, :availability, :bedside_manner, :efficacy, :comment 

  validates :user_id, :practitioner_name, :patient_type_id, :profession_id, :address, :wait_time, :availability, :bedside_manner, :efficacy, presence: true 

  def recommendation
    @recommendation ||= Recommendation.new({
      user_id:           user_id, 
      profession_id:     profession_id,
      patient_type_ids:  [ patient_type_id ],
      wait_time:         wait_time,
      availability:      availability,
      bedside_manner:    bedside_manner,
      efficacy:          efficacy,
      comment:           comment,
      practitioner:      practitioner   
    })
  end

  def practitioner
    @practitioner ||= Practitioner.find_by_fullname(practitioner_name) || Practitioner.new
  end

  def process
    if self.valid?
      update_practitioner
      recommendation.save
    else
      false
    end
  rescue NameError => e
    errors.add(:address, I18n.t('errors.address_parser')) && false
  rescue 
    errors[:base] << I18n.t('errors.general') && false
  end

  private
  def update_practitioner
    input_practitioner  = Digest::MD5.hexdigest("#{practitioner_name}-#{profession_id}-#{address}") 
    actual_practitioner = Digest::MD5.hexdigest("#{practitioner.fullname}-#{practitioner.primary_occupation.profession_id}-#{practitioner.address}")
    
    return if input_practitioner == actual_practitioner

    practitioner.fullname = practitioner_name
          
    practitioner.address  = address
    practitioner.status   = :not_indexed
          
    practitioner.add_occupation profession_id
    practitioner.save
  end
end