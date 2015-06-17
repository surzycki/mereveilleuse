class ApplicationController < ActionController::Base  
  protect_from_forgery with: :null_session
  # For the entry point we have to skip the authenticity validations, as the post is coming from facebook
  # In general for the moment we are going to ignore everything as it seems there are issues
  skip_before_action :verify_authenticity_token
  
  before_action :set_p3p, :set_device_type
  after_action :allow_iframe
  
  helper_method :current_user

  rescue_from Exception, with: :catch_error

  def warden
    env['warden']
  end

  def current_user
    warden.user scope: :user
  end

  def authenticated?
    redirect_to root_path unless warden.authenticated?(:user) 
  end

  def redirect_authenticated_user_to_search!
    redirect_to new_search_path if current_user
  end

  def token_authentication!
    # until we move authentication into warden this is how
    # we handle token authentication, when we move facebook authentication
    # into warden we can use warden to try each strategy and authenticate accordinly
    # CAVEAT: this could lead to folks with multiple account not being able to 
    # properly de register unless we handle token authentication first before facebook authentication
    warden.authenticate!(:token, scope: :user)
  end

  private
  # Rails 4 has a problem with iframes, this allows it to display content in an iframe
  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  # Explorer needs this to write cookies from inside an iframe
  def set_p3p  
    headers['P3P'] = 'CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV"'  
  end 

  def set_device_type
    request.variant = :phone if browser.mobile?
  end

  def catch_error(exception)
    TrackError.new(exception)
  end
end
