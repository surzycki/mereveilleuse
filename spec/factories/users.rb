FactoryGirl.define do
  factory :user, aliases: [ :recommender ] do
    firstname     'User'
    lastname      'Person'
    email         'user.person@example.com'
    facebook_id   '1111111'
    has_invited   false
    profile_image 'http://riverboatsmusic.com.au/wp-content/uploads/2014/09/1shuu4q3.wizardchan.test_.png'
    
    status        User.statuses[:registered] 

    location
  end
end
