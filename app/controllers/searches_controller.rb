class SearchesController < ApplicationController
  def new
    @form = SearchForm.new
  end

  def create
    search_service.on :success do |search_form|
      render json: { message: 'success'  }, status: :ok
    end

    search_service.on :fail do |search_form|
      render json: search_form.errors, status: :bad_request
    end

    search_service.execute DelayedEmailSearchProvider
  end

  private
  def search_params
    params.require(:search_form).permit(:address, :profession_id, :patient_id, :information )
  end

  def search_service
    @search_service ||= SearchService.new(SearchForm.new(search_params), current_user)
  end
end
