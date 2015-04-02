class SearchService
  include Wisper::Publisher

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def execute(provider)
    if form.process
      results = provider.execute form.search
      
      publish :search_success, results
    else
      publish :search_fail, form.errors
    end
  end
end