# wip
class RecommendationsWizardController < ApplicationController
  before_filter :load_form, only: [ :edit, :update ]

  around_filter :catch_exceptions, unless: 'Rails.env.development?'

  # GET recommendations_wizard/new
  def new
    @form = RecommendationWizardForm.new 
  end 

  # POST recommendations_wizard
  def create
    @form = RecommendationWizardForm.new Recommendation.new, find_practitioner_by_name
    
    recommendation_wizard = initialize_recommendation_wizard
    
    recommendation_wizard.next_step 
  end

  # GET recommendations_wizard/:id/edit
  def edit
    render :new
  end

  # PUT recommendations_wizard/:id
  def update
    recommendation_wizard = initialize_recommendation_wizard
    
    recommendation_wizard.execute
  end

  # GET recommendations_wizard/:id
  def show
  end

  private
  def initialized_recommedation_wizard
    recommendation_wizard ||= RecommendationWizard.new @form

    recommendation_wizard.on :on_next_step do |form|
      redirect_to edit_recommendation_wizard_path(form.recommendation)
    end
    
    recommendation_wizard.on :complete do |form|
      current_user.registered!
      redirect_to recommendation_wizard_path(form.recommendation)
    end

    recommendation_wizard.on :fail do |errors|
      flash.now[:alert] = errors.full_messages
      render :new
    end

    recommendation_wizard
  end

  def recommendation_wizard_params
    params.require(:recommendation_wizard_form).permit(:practitioner_name, :user_id, :patient_type_id, :profession_id, :address, :wait_time, :availability, :bedside_manner, :efficacy, :comment)
  end

  def load_form
    @form = RecommendationWizardForm.new Recommendation.find(params[:id])
  end

  def find_practitioner_by_name
    Practitioner.find_by_fullname recommendation_wizard_params[:practitioner_name]
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end