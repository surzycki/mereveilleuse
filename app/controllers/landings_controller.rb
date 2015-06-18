class LandingsController < ApplicationController
  around_action :catch_exceptions, unless: 'Rails.env.development?'
  before_action :redirect_authenticated_user_to_search!

  # GET /sinscrire
  def unbounce
  end

  # GET /
  def index
    respond_to do |format|
      format.html do |html|
        html.any    { render layout: 'application_only_footer' }
        html.phone  { render layout: 'application' } 
      end
    end
  end 

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end
