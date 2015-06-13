class RegistrationsController < ApplicationController
  around_action :catch_exceptions, unless: 'Rails.env.development?'

  # GET registrations/new
  def new
    @form = RecommendationForm.new

    respond_to do |format|
      format.html do |html|
        html.any    { render layout: 'application_only_footer' }
        html.phone  { render layout: 'application' } 
      end
    end
  end

  # GET registrations/invite
  def invite
    respond_to do |format|
      format.html do |html|
        html.any    { render layout: 'application_only_footer' }
        html.phone  { render layout: 'application' } 
      end
    end
  end 

  # POST recommendations
  def create
    byebug
    @form = RecommendationForm.new recommendation_params
  end

  private
  def recommendation_params
    params.require(:recommendation_form)
      .permit(:practitioner_name, :patient_type_id, :profession_name, :address, :wait_time, :availability, :bedside_manner, :efficacy, :comment )
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end
