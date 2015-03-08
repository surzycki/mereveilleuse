class SessionsController < ApplicationController
  around_filter :catch_exceptions

  # GET /session
  # POST /session
  def index 
    Authentication.new(self).tap do |auth|
      auth.with facebook_authentication
    end
    #on_authentication_success User.first
  end

  def on_authentication_success(account)
    # set user_id in env for the authentication since we
    # aren't passing these during a via parmas in a post
    #env['user_id'] = account.id
    warden.set_user account
    #warden.authenticate!
    #on_registration_success
  end

  def on_authentication_fail(exception = nil )
    if exception
      Raygun.track_exception(exception)
      logger.error("EXCEPTION CAUGHT: #{exception}")
    end

    redirect_to not_found_path
  end

  def on_registration_success 
    session['test'] = 'hello'
    redirect_to referral_path
  end

  def on_login_success
    session['test'] = 'hello'
    redirect_to search_path
  end
 
  private
  # Facebook posts a signed_request to upon arriving to the canvas
  def facebook_authentication
    @facebook_authentication ||= FacebookAuthentication.new(params[:signed_request])
  end

  def catch_exceptions
    yield
  rescue => error  
    Raygun.track_exception(error)
    logger.error("EXCEPTION CAUGHT: #{error}")
    redirect_to not_found_path
  end
end
