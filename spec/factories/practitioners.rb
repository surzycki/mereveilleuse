FactoryGirl.define do
  factory :practitioner do
    firstname       'Mister'
    lastname        'Practitioner'
    email           'practitioner@example.com'
    phone           '0122334455'
    mobile_phone    '0611223344'
    status          Practitioner.statuses[:indexed] 

    location

    occupations do |practitioner|
      Array.new(1) { practitioner.association :occupation }
    end
  end
end
