class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  #protect_from_forgery with: :exception

  after_filter :allow_iframe


  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end 
end
