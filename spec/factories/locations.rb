FactoryGirl.define do
  factory :location do
    street      '6 rue gobert'
    city        'paris'
    postal_code '75011'
    country     'france'
    latitude      1.111
    longitude     2.222

    trait :blank do
      street      ''
      city        ''
      postal_code ''
      country     ''
      latitude    0
      longitude   0
    end
  end
end
