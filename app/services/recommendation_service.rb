class RecommendationService
  include Wisper::Publisher

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def create
    if form.process
      publish :recommendation_created, recommendation
    else
      publish :recommendation_create_fail, form.errors
    end
  end

  def recommendation
    form.recommendation
  end
end