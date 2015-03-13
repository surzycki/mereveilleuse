FactoryGirl.define do
  factory :recommendation_form do
    practitioner_name   'Mister Practitioner'
    practitioner_id     '1004'
    patient_type        '2'
    profession          '3'
    address             '123 East Street, Paris, France'
    user                '4'
    wait_time           '4'
    availability        '4'
    bedside_manner      '4'
    efficacy            '4'
    comment             'Hello there this is a comment'
  end
end