Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 
    ENV['FACEBOOK_APP_ID'], 
    ENV['FACEBOOK_SECRET'],
    { 
      scope: 'public_profile,email,user_friends,user_location',
      info_fields: 'friends,email,first_name,last_name,location,verified',
      image_size: 'large' 
    }

  on_failure { |env| IdentitiesController.action(:failure).call(env) }
end