class RecommendationForm 
  include ActiveModel::Model

  attr_accessor :fullname, :patient_type, :profession, :address, :user,
                :wait_time, :availability, :bedside_manner, :efficacy, :comment
                
end