class SearchService
  include Wisper::Publisher

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def execute(provider)
    if form.process
      provider.execute form.search
      
      publish :success, form.search
    else
      publish :fail, form.errors
    end
  end
end