FactoryGirl.define do
  factory :location do
    street            '6 rue gobert'
    city              'paris'
    postal_code       '75011'
    country           'france'
    latitude            1.111
    longitude           2.222
    unparsed_address  '6 rue gobert paris france'
    status            Location.statuses[:geocoded]  

    trait :blank do
      street            ''
      city              ''
      postal_code       ''
      country           ''
      latitude          0
      longitude         0
      unparsed_address  ''
      status            Location.statuses[:not_geocoded]
    end

    trait :not_geocoded do
      blank
      unparsed_address '1 rue champs elyssse'
      status            Location.statuses[:not_geocoded]
    end
  end
end
