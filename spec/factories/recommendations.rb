FactoryGirl.define do
  factory :recommendation do
    wait_time       4
    availability    4
    bedside_manner  4
    efficacy        4
    comment         'Not bad'

    user
    practitioner
    profession

    patient_types do |practitioner|
      Array.new(1) { practitioner.association :patient_type }
    end
  end
end
