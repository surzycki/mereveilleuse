class RegistrationService
  include Wisper::Publisher

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def register(registration_type=nil)
    if form.process
      publish :user_created, user, registration_type
    else
      publish :user_create_fail, form.errors
    end
  end

  def user
    form.user
  end
end