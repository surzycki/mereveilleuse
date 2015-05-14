FactoryGirl.define do
  # NOTE: md5 hash is not correctly generated with the after_initialize
  #       this is primarily because the association are not created
  #       until after the init and we expect them to be there during the init
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
    information     'Hello there'

    settings   ''
  end
end