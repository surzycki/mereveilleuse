class RecommendationForm 
  include ActiveModel::Model

  attr_reader   :practitioner, :recommendation, :practitioner_id 

  attr_accessor :practitioner_name, :patient_type, :profession, :address, :user,
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
    after_transition from: :step_three do |object|
      
    end

    state :step_one do
      def form_fields
        [:practitioner_name, :practitioner_id, :user, :patient_type, :profession, :address]
      end

      def save
        attributes = hashify(:user, :profession )
                      .merge(patient_type_ids: [ @patient_type ] )
                      .merge(practitioner_id: @practitioner.id )
        
        @recommendation.update_attributes attributes
      end
    end

    state :step_two do
      def form_fields
        [:wait_time, :availability, :bedside_manner, :efficacy, :comment]
      end

      def save
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

  def initialize(recommendation, practitioner)
    @practitioner    = practitioner
    @practitioner_id = practitioner.id
    @recommendation  = recommendation
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
end