class PractitionersController < ApplicationController
  around_action :catch_exceptions, unless: 'Rails.env.development?'

  # GET practitioners/autocomplete?query={query}
  def autocomplete
    respond_to do |format|
      format.json { create_json_response }
      format.html { redirect_to root_path }
    end
  end

  private
  def create_json_response
    @results = Practitioner.search( params[:query], fields: [ {fullname: :word_start} ], limit: 10).results
    
    render :autocomplete
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    render json: {error: [ error ]}, status: :internal_server_error
  end
end