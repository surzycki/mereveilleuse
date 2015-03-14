FactoryGirl.define do
  factory :recommendation do
    trait :step_one_complete do
      user
      practitioner
      profession

      patient_types do |practitioner|
        Array.new(1) { practitioner.association :patient_type }
      end

      state 'step_two'
    end

    trait :step_two_complete do
      step_one_complete
      
      wait_time       4
      availability    4
      bedside_manner  4
      efficacy        4
      comment         'Not bad'

      state 'step_three'
    end

    trait :completed do
      step_one_complete
      step_two_complete

      state 'completed'
    end
  end
end
