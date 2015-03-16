class RecommendationsController < ApplicationController
  before_filter :load_form, only: [ :edit, :update ]

  around_filter :catch_exceptions, unless: 'Rails.env.development?'

  # GET recommendations/new
  def new
    @form = RecommendationForm.new 
  end 

  # POST recommendations
  def create
    @form = RecommendationForm.new Recommendation.new, find_practitioner_by_name
    
    RecommendationWizard.new(self).tap do |wizard|
      wizard.set @form, recommendation_params
    end 
  end

  # GET recommendations/:id/edit
  def edit
    render :new
  end

  # PUT recommendations/:id
  def update
    RecommendationWizard.new(self).tap do |wizard|
      wizard.set @form, recommendation_params
    end 
  end

  # GET recommendations/:id
  def show

  end

  # event listeners
  def on_next_step(form)
    redirect_to edit_recommendation_path(form.recommendation)
  end

  def on_form_complete(form)
    current_user.registered!
    redirect_to recommendation_path(form.recommendation)
  end

  def on_form_error(errors)
    flash.now[:alert] = errors.full_messages
    render :new
  end

  private
  def recommendation_params
    params.require(:recommendation_form).permit(:practitioner_name, :user_id, :patient_type_id, :profession_id, :address, :wait_time, :availability, :bedside_manner, :efficacy, :comment)
  end

  def load_form
    @form = RecommendationForm.new Recommendation.find(params[:id])
  end

  def find_practitioner_by_name
    Practitioner.find_by_fullname recommendation_params[:practitioner_name]
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, logger )
    redirect_to not_found_path
  end
end
