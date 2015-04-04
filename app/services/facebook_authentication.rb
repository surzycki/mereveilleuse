class FacebookAuthentication
  def self.stub(params)
    OpenStruct.new(
      firstname:     params.firstname,
      lastname:      params.lastname,
      email:         params.email,
      address:       params.address, 
      facebook_id:   params.facebook_id,
      profile_image: params.profile_image,
      friend_count:  10,
      verified:      true,
      authenticated: true,
      redirect_path: nil
    )
  end

  attr_reader :signed_request, :redirect_path, :firstname, :lastname, :email, :facebook_id, :address, :authenticated, :profile_image, :verified, :friend_count

  # Authenticates user to facebook using signed requests
  # FACEBOOK_APP_ID and FACEBOOK_SECRET should be set in the ENV vars 
  #
  # @param signed_request [SignedRequest] the facebook
  def initialize(signed_request, app_data=nil)
    @signed_request = signed_request
    
    process_app_data app_data
    
    authenticate
  end

  private 
  def authenticate
    @authenticated    = false
    oauth             = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'])
    validated_request = oauth.parse_signed_request(@signed_request)
    facebook_api      = Koala::Facebook::API.new(validated_request['oauth_token'])

    set_attributes      facebook_api
    set_profile_image   facebook_api
    set_friend_count    facebook_api
    
    @authenticated = true
  rescue Exception => e
    @authenticated = false
  end

  def set_attributes(api)
    json = api.get_object('me').with_indifferent_access
    
    @firstname      = json[:first_name]
    @lastname       = json[:last_name]
    @email          = json[:email]
    @facebook_id    = json[:id]
    @verified       = json.fetch(:verified, false)
    
    @address        = json[:location][:name] if json[:location]
  end

  def set_profile_image(api)
    @profile_image = api.get_picture(@facebook_id, type: 'large')
  end

  def set_friend_count(api)
    @friend_count = api.get_connections('me', 'friends').raw_response['summary']['total_count']
  rescue Exception => e
    @friend_count = 0
  end

  def process_app_data(app_data)
    @redirect_path = app_data
  end
end