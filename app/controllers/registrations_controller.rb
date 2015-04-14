class RegistrationsController < ApplicationController
  around_filter :catch_exceptions, unless: 'Rails.env.development?'

  # GET registrations/new
  def new
    #@requesting_authentication = params[:requesting_authentication]
  end 

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end
