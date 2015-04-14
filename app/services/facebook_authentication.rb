class FacebookAuthentication
  # DEPRECIATED
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

  attr_reader :signed_request, :cookies, :redirect_path, :firstname, :lastname, :email, :facebook_id, :address, :authenticated, :profile_image, :verified, :friend_count, :platform

  # Authenticates user to facebook using signed requests
  # FACEBOOK_APP_ID and FACEBOOK_SECRET should be set in the ENV vars 
  #
  # @param cookies        [Cookies] the facebook
  # @param signed_request [String]  Posted during canvas authentication
  # @param app_data       [String]  Appended to url for redirection in canvas apps 
  def initialize(cookies: raise(ArgumentError), app_data: nil, signed_request: nil )
    @cookies        = cookies
    @signed_request = signed_request

    process_app_data  app_data
    set_platform      signed_request

    authenticate
  end

  private 
  def authenticate
    @authenticated    = false
    
    facebook_api      = get_facebook_api
  
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

  def get_facebook_api
    oauth = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'])

    token = if signed_request.nil?
      user_info = oauth.get_user_info_from_cookies(cookies)
      user_info['access_token']
    else
      user_info = oauth.parse_signed_request(signed_request)
      user_info['oauth_token']
    end

    facebook_api = Koala::Facebook::API.new(token)
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

  def set_platform(signed_request)
    @platform = if signed_request.nil? 
      User.platforms.key(User.platforms['web']) 
    else 
      User.platforms.key(User.platforms['canvas']) 
    end
  end
end