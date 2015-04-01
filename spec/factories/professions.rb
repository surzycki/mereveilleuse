FactoryGirl.define do
  factory :profession do
    name      'Osteopathe'    
    status    Profession.statuses[:indexed]   
  end
end
