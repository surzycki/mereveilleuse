FactoryGirl.define do
  factory :search do
    patient_types do |search|
      Array.new(1) { search.association :patient_type }
    end

    professions do |search|
      Array.new(1) { search.association :profession }
    end

    user
    location
    status          Search.statuses[:active] 
    latitude        44.2
    longitude       2.2
    information     'Hello there'

    settings   ''
  end
end