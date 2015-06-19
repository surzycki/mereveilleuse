class RegistrationsController < ApplicationController
  around_action :catch_exceptions, unless: 'Rails.env.development?'

  # GET registration/new
  def new
    @form = RecommendationForm.new

    respond_to do |format|
      format.html do |html|
        html.any    { render layout: 'application' }
        html.phone  { render layout: 'application' } 
      end
    end
  end

  # GET registration/invite
  def invite
    respond_to do |format|
      format.html do |html|
        html.any    { render layout: 'application_only_footer' }
        html.phone  { render layout: 'application' } 
      end
    end
  end 

  # POST /registration
  def create
    
    @form = RecommendationForm.new registration_params

    # recommendations (practitioners) are not geocoded by default to lessen
    # the burden on the system, practitioners are geocoded only when a
    # new recommendation is made.
    recommendation_service.subscribe( 
      GeocodeListener.new,
      on: :recommendation_created,
      with: :recommendation 
    )

    recommendation_service.on :recommendation_created do |recommendation|
      session[:recommendation_id] = recommendation.id
      redirect_to registration_identity_path
    end

    recommendation_service.on :recommendation_create_fail do |errors|
      flash.now[:alert] = errors.full_messages.join(', ')
      render :new
    end

    recommendation_service.create
  end

  # GET /registration/identity
  def identity
    # are we registering by recommending or by inviting
    set_registration_type
  end

  private
  def registration_params
    params.require(:recommendation_form)
      .permit(:practitioner_name, :patient_type_id, :profession_name, :address, :wait_time, :availability, :bedside_manner, :efficacy, :comment )
  end

  def recommendation_service
    @recommendation_service ||= RecommendationService.new(@form)
  end

  def set_registration_type
    @registration_type ||= params[:registration_type] || 'recommendation'
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end
