class Authentication
  attr_reader :listener, :fb_auth

  def initialize(listener)
    @listener = listener
  end

  # Authenticates user to platform
  # @param facebook_authentication [FacebookAuthentication] 
  def with(facebook_authentication)
    @fb_auth = facebook_authentication

    begin
      account = User.find_or_create_by(facebook_id: @fb_auth.facebook_id)
  
      account.update(
        firstname: fb_auth.firstname,
        lastname:  fb_auth.lastname,
        email:     fb_auth.email
      )

      @listener.on_authentication_success account

      if account.registered?
        @listener.on_login_success 
      else
        @listener.on_registration_success 
      end
  
    rescue Exception => error
      @listener.on_authentication_fail error
    end
  end
end