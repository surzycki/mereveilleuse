FactoryGirl.define do
  factory :recommendation do
    trait :step_two do
      user
      practitioner
      profession

      patient_types do |practitioner|
        Array.new(1) { practitioner.association :patient_type }
      end

      state 'step_two'
    end

    trait :completed do
      step_two
      
      wait_time       4
      availability    4
      bedside_manner  4
      efficacy        4
      comment         'Not bad'

      state 'completed'
    end
  end
end
