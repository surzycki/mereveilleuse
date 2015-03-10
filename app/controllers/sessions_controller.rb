class SessionsController < ApplicationController
  # For the entry point we have to skip the authenticity validations, as the post is coming
  # from facebook
  skip_before_filter :verify_authenticity_token, only: :index
  around_filter :catch_exceptions

  # GET /session
  # POST /session
  def index 
    # for testing
    if request.method == 'GET'
      on_authentication_success(User.last)
      on_registration_success
    else
      Authentication.new(self).tap do |auth|
        auth.with facebook_authentication
      end
    end
  end


  # event listeners
  def on_authentication_success(account)
    # set user_id in env for the authentication since we
    # aren't passing these during a via parmas in a post
    warden.set_user account, scope: :user
  end

  def on_authentication_fail(exception = nil )
    if exception
      Raygun.track_exception(exception)
      logger.error("EXCEPTION CAUGHT: #{exception}")
    end

    redirect_to not_found_path
  end
  
  def on_registration_success 
    redirect_to new_recommendation_path
  end

  def on_login_success
    redirect_to new_search_path
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
