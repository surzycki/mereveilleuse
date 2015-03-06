class SessionsController < ApplicationController
  # Facebook posts to index entry point, so disable CSRF for this action
  skip_before_filter :verify_authenticity_token, only: :index

  def index 
    
    i = 10
  end
end
