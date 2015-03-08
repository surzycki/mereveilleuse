class SessionsController < ApplicationController
  before_action :oauth_facebook_authentication
  
  # GET /session
  # POST /session
  def index 
    # authenticate/register with local app
    
    Authentication.new(self).tap do |auth|
      args = Koala::Facebook::API.new(@signed_request['oauth_token']).get_object('me')
      auth.with args
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
    logger.error("EXCEPTION CAUGHT: #{exception}")
    redirect_to not_found_path
  end
   
  private
  # Facebook posts a signed_request to upon arriving to the canvas
  def oauth_facebook_authentication
    begin
      oauth = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'])
      @signed_request = oauth.parse_signed_request(params[:signed_request])
    rescue 
      redirect_to not_found_path 
    end
  end
end
