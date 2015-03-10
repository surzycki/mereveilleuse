class RecommendationForm 
  include ActiveModel::Model

  attr_accessor :practitioner, :patient_type, :profession, :address, :user, :recommendation,
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
        [:practitioner, :patient_type, :profession, :address]
      end
    end

    state :step_two do
      def form_fields
        [:wait_time, :availability, :bedside_manner, :efficacy, :comment]
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

  def initialize(recommendation)
    @recommendation = recommendation
  end

  def save
    @recommendation.save
  end
end