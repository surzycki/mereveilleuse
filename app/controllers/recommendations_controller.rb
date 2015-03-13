class RecommendationsController < ApplicationController
  before_filter :load_form,   only: [ :edit, :update ]

  around_filter :catch_exceptions

  # GET recommendations/new
  def new
    @form = RecommendationForm.new Recommendation.new, Practitioner.new
  end 

  # POST recommendations
  def create 
    @form = RecommendationForm.new Recommendation.new, Practitioner.find_or_create_by( id: recommendation_params['practitioner_id'] )

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

  # event listeners
  def on_next_step(form)
    redirect_to edit_recommendation_path(form.recommendation)
  end

  def on_form_error(errors)
    flash.now[:alert] = errors
    render :new
  end

  private
  
  def recommendation_params
    params.require(:recommendation_form).permit(@form.form_fields)
  end

  def load_form
    @form = RecommendationForm.new Recommendation.find(params[:id])
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, logger )
    redirect_to not_found_path
  end
end
