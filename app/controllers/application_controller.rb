class ApplicationController < ActionController::Base
  # Facebook canvas apps can't retrieve signed cookie (iframe)
  #protect_from_forgery with: :null_session
  protect_from_forgery with: :exception
  before_filter :set_p3p  
  after_filter :allow_iframe


  # Rails 4 has a problem with iframes, this allows it to display
  # content in an iframe
  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def set_p3p  
    headers['P3P'] = 'CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV"'  
  end 
end
