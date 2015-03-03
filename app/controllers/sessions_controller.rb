class SessionsController < ApplicationController
  def index
    session[:hello] = 'hello'
    i = 10
  end
end
