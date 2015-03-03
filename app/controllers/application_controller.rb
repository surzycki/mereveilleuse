class ApplicationController < ActionController::Base
  # Facebook canvas apps can't retrieve signed cookie (iframe)
  #protect_from_forgery with: :null_session
  protect_from_forgery with: :exception
  after_filter :allow_iframe


  # Rails 4 has a problem with iframes, this allows it to display
  # content in an iframe
  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end 
end
