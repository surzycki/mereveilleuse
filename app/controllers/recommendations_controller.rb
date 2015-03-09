class RecommendationsController < ApplicationController
  
  
  def index
    @form = RecommendationForm.new
  end 
end
