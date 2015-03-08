class ApplicationController < ActionController::Base
  # TODO: Facebook canvas apps can't retrieve signed cookie (iframe), not super secure
  # just a whole lot easier
  protect_from_forgery with: :null_session
  
  before_filter :set_p3p
  after_filter :allow_iframe
  
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
