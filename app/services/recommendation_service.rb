class RecommendationService
  include Wisper::Publisher

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def submit
    if form.process
      publish :success, form.recommendation
    else
      publish :fail, form.errors
    end
  end
end