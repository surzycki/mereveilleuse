class SearchesController < ApplicationController
  before_filter :authenticated?
  around_filter :catch_exceptions, unless: 'Rails.env.development?'

  # GET search
  def new
    @form = SearchForm.new
  end

  # POST search
  def create
    @form = SearchForm.new search_params

    search_service.on :search_success do |results, search|
      redirect_to search_path
    end

    search_service.on :search_fail do |errors|
      flash.now[:alert] = errors.full_messages.join(', ')
      render :new
    end
    
    search_service.execute RecommendationsEmailProvider.new
  end

  # GET show
  def show
  end


  private
  def search_params
    params.require(:search_form)
      .permit(:address, :profession_id, :patient_type_id, :information )
      .merge(user_id: current_user.id)
  end

  def search_service
    @search_service ||= SearchService.new(@form)
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    
    redirect_to internal_server_error_path
  end
end
