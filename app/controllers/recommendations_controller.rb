class RecommendationsController < ApplicationController
  around_action :catch_exceptions, unless: 'Rails.env.development?'

  # GET recommendations/new
  def new
    @requesting_authentication = params[:requesting_authentication]
    @form = RecommendationForm.new
  
  end

  # POST recommendations
  def create
    @form = RecommendationForm.new recommendation_params
    
    # recommendations (practitioners) are not geocoded by default to lessen
    # the burden on the system, practitioners are geocoded only when a
    # new recommendation is made.
    recommendation_service.subscribe( 
      GeocodeListener.new,
      on: :recommendation_created,
      with: :recommendation 
    )

    recommendation_service.on :recommendation_created do |recommendation|
      current_user.registered!
      redirect_to recommendation_path(recommendation)
    end

    recommendation_service.on :recommendation_create_fail do |errors|
      flash.now[:alert] = errors.full_messages.join(', ')
      render :new
    end

    recommendation_service.create_recommendation
  end

  # GET recommendations
  def show
  end

  private
  def recommendation_params
    params.require(:recommendation_form)
      .permit(:practitioner_name, :patient_type_id, :profession_name, :address, :wait_time, :availability, :bedside_manner, :efficacy, :comment )
      .merge(user_id: current_user.id)
  end

  def recommendation_service
    @recommendation_service ||= RecommendationService.new(@form)
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end