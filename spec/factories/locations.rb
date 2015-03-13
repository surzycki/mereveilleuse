FactoryGirl.define do
  factory :location do
    street      '123 East Street'
    city        'Paris'
    postal_code '75011'
    country     'France'
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
