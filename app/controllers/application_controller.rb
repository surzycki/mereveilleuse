class ApplicationController < ActionController::Base  
  # For the entry point we have to skip the authenticity validations, as the post is coming from facebook
  # In general for the moment we are going to ignore everything as it seems there are issues
  skip_before_filter :verify_authenticity_token
  #protect_from_forgery with: :null_session

  before_filter :set_p3p
  after_filter :allow_iframe
  
  helper_method :current_user

  def warden
    env['warden']
  end

  def current_user
    warden.user scope: :user
  end

  def authenticated?
    redirect_to new_registration_path unless warden.authenticated?(:user) 
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
end
