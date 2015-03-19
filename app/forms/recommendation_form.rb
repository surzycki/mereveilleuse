class RecommendationForm 
  include ActiveModel::Model

  attr_reader   :practitioner, :recommendation

  attr_accessor :practitioner_name, :patient_type_id, :profession_id, :address, :user_id,
                :wait_time, :availability, :bedside_manner, :efficacy, :comment
                
  delegate :state, :state=, to: :recommendation
  
  state_machine :state, initial: :step_one do
    before_transition do |object, transaction|
      object.valid? ? object.save : false
    end

    after_transition do |object, transaction|
      # save state
      object.recommendation.save
    end

    state :step_one do
      validates :practitioner_name, :user_id, :patient_type_id, :profession_id, :address, presence: true 
     
      def save 
        recommendation.attributes   = hashify(:user_id, :profession_id ).merge(patient_type_ids: [ patient_type_id ] )
        recommendation.practitioner = practitioner
        
        # someone has changed the practitioner information needs to be handled
        if update_practitioner?
          practitioner.fullname = practitioner_name
          practitioner.address  = address
          practitioner.status   = :not_indexed
          
          practitioner.add_occupation profession_id
          practitioner.save
        end  
      rescue NameError => e
        errors.add(:address, I18n.t('errors.address_parser')) && false
      rescue 
        errors[:base] << I18n.t('errors.general') && false
      end
    end

    state :step_two do
      validates :wait_time, :availability, :bedside_manner, :efficacy, :comment, presence: true 

      def save
        recommendation.attributes = hashify(:wait_time, :availability, :bedside_manner, :efficacy, :comment )
      rescue 
        false      
      end
    end

    event :next_step do
      transition step_one: :step_two
      transition step_two: :completed
    end
  end


  def attributes=(attr)
    attr.each do |k, v| 
      self.send("#{k}=", v) 
    end
  end

  def initialize(recommendation = nil, practitioner = nil)
    @practitioner   = practitioner || Practitioner.new
    @recommendation = recommendation || Recommendation.new
  end

  def update_practitioner?
    # is a new practitioner, go ahead and update
    return true if practitioner.primary_occupation.nil?

    input  = Digest::MD5.hexdigest("#{practitioner_name}-#{profession_id}-#{address}") 
    actual = Digest::MD5.hexdigest("#{practitioner.fullname}-#{practitioner.primary_occupation.profession_id}-#{practitioner.address}")
    
    input != actual
  end

  # turns attrs in hash, removes blanks
  def hashify(*attrs)
    Hash[*[attrs.map do |attr|
      [attr, send(attr)]
    end].flatten].delete_if { |k,v| v.blank? }
  end
end