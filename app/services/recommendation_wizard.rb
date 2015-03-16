class RecommendationWizard
  attr_reader :listener

  def initialize(listener)
    @listener = listener
  end

  def set(form, attributes)
    form.attributes = attributes
    
    if form.next_step
      @listener.on_next_step(form)     if form.state != 'completed'
      @listener.on_form_complete(form) if form.state == 'completed'
    else
      @listener.on_form_error form.errors
    end
  end
end