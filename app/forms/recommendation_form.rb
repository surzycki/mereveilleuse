class RecommendationForm 
  include ActiveModel::Model

  attr_reader   :practitioner, :recommendation

  attr_accessor :practitioner_id, :practitioner_name, :patient_type, :profession, :address, :user,
                :wait_time, :availability, :bedside_manner, :efficacy, :comment
                
  delegate :state, :state=, to: :recommendation
  
  state_machine :state, initial: :step_one do
    before_transition do |object, transaction|
      object.valid?
    end

    after_transition do |object, transaction|
      object.save
    end

    # finalize
    #after_transition from: :step_three do |object|
      
    #end

    state :step_one do
      validates :practitioner_name, :practitioner_id, :user, :patient_type, :profession, :address, presence: true 
     
      def form_fields
        [:practitioner_name, :user, :patient_type, :profession, :address]
      end

      def save
        attributes = hashify(:user, :profession )
                      .merge(patient_type_ids: [ patient_type ] )
                      .merge(practitioner_id: practitioner.id )
        
        recommendation.update_attributes attributes

        # someone has changed the practitioner information needs to be handled
        if update_practitioner?
          practitioner.fullname = practitioner_name
          practitioner.address  = address

          practitioner.add_occupation profession
          practitioner.not_indexed!
        end
      end
    end

    state :step_two do
      validates :wait_time, :availability, :bedside_manner, :efficacy, presence: true 

      def form_fields
        [:wait_time, :availability, :bedside_manner, :efficacy, :comment]
      end

      def save
        attributes = hashify(:wait_time, :availability, :bedside_manner, :efficacy, :comment )
        
        recommendation.update_attributes attributes
      end
    end

    state :step_three do
      
    end

    event :next_step do
      transition step_one: :step_two
      transition step_two: :step_three
      transition step_three: :completed
    end
  end


  def attributes=(attr)
    attr.each do |k, v| 
      self.send("#{k}=", v) 
    end
  end

  def initialize(recommendation = nil, practitioner = nil)
    
    @practitioner    = practitioner || Practitioner.new
    @practitioner_id = practitioner.try(:id)
    @recommendation  = recommendation || Recommendation.new
  end

  # turns attrs in hash, removes blanks
  # eg: 
  #     firstname = 'Joe'
  #     lastname  = ''
  #     hashify :firstname, :lastname => { firstname: 'Joe' }
  def hashify(*attrs)
    Hash[*[attrs.map do |attr|
      [attr, send(attr)]
    end].flatten].delete_if { |k,v| v.blank? }
  end

  # determines if the practitioner needs updating
  # by hashing modifiable attributes against current practitioner
  def update_practitioner?
    # is a new practitioner, go ahead and update
    return true if practitioner.primary_occupation.nil?

    input  = Digest::MD5.hexdigest("#{practitioner_name}-#{profession}-#{address}") 
    actual = Digest::MD5.hexdigest("#{practitioner.fullname}-#{practitioner.primary_occupation.id}-#{practitioner.address}")
    
    input != actual
  end
end