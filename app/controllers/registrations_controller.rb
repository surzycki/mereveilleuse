class RegistrationsController < ApplicationController
  around_filter :catch_exceptions, unless: 'Rails.env.development?'

  # GET registrations/new
  def new
    @form = RecommendationForm.new
  end 

  # POST registrations
  def create
    #@form = RecommendationForm.new registration_params
    #
    #recommendation_service.on :success do |recommendation|
    #  current_user.registered!
    #  redirect_to recommendation_path(recommendation)
    #end
#
    #recommendation_service.on :fail do |errors|
    #  flash.now[:alert] = errors.full_messages
    #  render :new
    #end
#
    #recommendation_service.execute
  end

  # GET registrations/:id
  def show
  end

  private
  def registration_params
    params.require(:registration_form).permit(:practitioner_name, :user_id, :patient_type_id, :profession_id, :address, :wait_time, :availability, :bedside_manner, :efficacy, :comment)
  end

  def recommendation_service
    @recommendation_service ||= RecommendationService.new(@form)
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, logger )
    redirect_to not_found_path
  end
end
