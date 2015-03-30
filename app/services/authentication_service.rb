class AuthenticationService
  include Wisper::Publisher

  # Authenticates user to platform
  # @param auth [FacebookAuthentication] 
  def authenticate(auth)
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

      publish :success, account, auth.redirect_path
    
    # catch address name error
    rescue NameError => error
      publish :success, account, auth.redirect_path  
    rescue Exception => error
      publish :fail, error
    end
  end
end