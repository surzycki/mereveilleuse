# wip
class RecommendationWizard
  include Wisper::Publisher

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def next_step(attributes)
    form.attributes = attributes
    
    if form.next_step
      publish :next_step, form    if form.state != 'completed'
      publish :complete,  form    if form.state == 'completed'
    else
      publish :fail, form.errors
    end
  end
end