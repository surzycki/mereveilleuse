class SearchService
  include Wisper::Publisher

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def execute(provider)
    if form.process
      results = provider.execute form.search
      
      publish :success, results
    else
      publish :fail, form.errors
    end
  end
end