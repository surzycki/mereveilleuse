class SessionsController < ApplicationController
  around_filter :catch_exceptions

  # GET /session
  # POST /session
  def index 
    Authentication.new(self).tap do |auth|
      auth.with facebook_authentication
    end
  end

  def on_registration_success 
    redirect_to referral_path
  end

  def on_login_success
    redirect_to search_path
  end

  def on_authentication_success(account)
    #sign_in account
  end

  def on_authentication_fail(exception)
    Raygun.track_exception(error)
    logger.error("EXCEPTION CAUGHT: #{error}")
    redirect_to not_found_path
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
