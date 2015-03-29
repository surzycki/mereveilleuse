class RegistrationsController < ApplicationController
  around_filter :catch_exceptions, unless: 'Rails.env.development?'

  # GET registrations/new
  def new
  end 

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, logger )
    redirect_to not_found_path
  end
end
