class RecommendationService
  include Wisper::Publisher

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def create_recommendation
    if form.process
      publish :recommendation_created, form.recommendation
    else
      publish :recommendation_create_fail, form.errors
    end
  end
end