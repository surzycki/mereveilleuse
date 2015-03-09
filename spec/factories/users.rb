FactoryGirl.define do
  factory :user do
    firstname     'User'
    lastname      'Person'
    email         'user.person@example.com'
    facebook_id   '1111111'
    has_invited   false
    state         ''
    status        User.statuses[:registered] 

    location
  end
end
