class RecommendationWizard
  attr_reader :listener

  def initialize(listener)
    @listener = listener
  end

  def set(form, attributes)
    form.attributes = attributes

    if form.next_step
      @listener.on_next_step form.recommendation
    else
      @listener.on_form_error form.errors
    end
  end
end