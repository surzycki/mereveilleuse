class RegistrationsController < ApplicationController
  around_filter :catch_exceptions, unless: 'Rails.env.development?'

  layout 'application_only_footer'
  
  # GET registrations/new
  def new
  end 

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end
