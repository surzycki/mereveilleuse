class AuthenticationService
  include Wisper::Publisher

  # Authenticates user to platform
  # @param auth [FacebookAuthentication] 
  def authenticate(auth)
    begin
      if auth.authenticated
        do_authentication auth
      else
        publish :request_authentication, auth
      end
    rescue Exception => error
      publish :authentication_fail, error
    end
  end

  private 
  def do_authentication(auth)
    account = get_account auth 
    if account.registered?
      publish :login, account, auth.redirect_path
    else
      publish :signup, account
    end
  end

  def get_account(auth)
    begin 
      account = User.find_or_create_by(facebook_id: auth.facebook_id)
    
      account.update(
        firstname:     auth.firstname,
        lastname:      auth.lastname,
        email:         auth.email,
        profile_image: auth.profile_image
      )
      
      # isolate update of address in case address not found error.  
      account.update(
        address: auth.address
      )
    rescue NameError => error
      # catch address name error and return account
    end

    account
  end
end