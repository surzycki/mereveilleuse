FactoryGirl.define do
  factory :recommendation do
    user
    practitioner
    profession

    patient_types do |practitioner|
      Array.new(1) { practitioner.association :patient_type }
    end
 
    wait_time       4
    availability    4
    bedside_manner  4
    efficacy        4
    comment         'Not bad'
    state           'completed'
  end
end
