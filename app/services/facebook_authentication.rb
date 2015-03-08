class FacebookAuthentication
  attr_reader :signed_request, :firstname, :lastname, :email, :facebook_id, :location_name, :authenticated

  # Authenticates user to facebook using signed requests
  # FACEBOOK_APP_ID and FACEBOOK_SECRET should be set in the ENV vars 
  #
  # @param signed_request [SignedRequest] the facebook
  def initialize(signed_request)
    @signed_request = signed_request
    authenticate
  end

  private 
  def authenticate
    @authenticated = false

    oauth             = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'])
    validated_request = oauth.parse_signed_request(@signed_request)
    facebook_api      = Koala::Facebook::API.new(validated_request['oauth_token'])

    set_attributes facebook_api.get_object('me')

    @authenticated = true
  rescue Exception => e
    @authenticated = false
  end

  def set_attributes(json)
    json = json.with_indifferent_access
    
    @firstname    = json[:first_name]
    @lastname     = json[:last_name]
    @email        = json[:email]
    @facebook_id  = json[:id]

    @location_name = json[:location][:name] if json[:location]
  end
end