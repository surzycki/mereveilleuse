class SearchService
  include Wisper::Publisher

  def initialize(form, current_user)
    @form = form
    @user = current_user
  end

  def execute(provider)
    if form.save
      publish :success, form
    else
      publish :fail, form
    end
  end
end