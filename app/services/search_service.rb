class SearchService
  include Wisper::Publisher

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def execute(provider)
    if form.process
      do_search provider
    else
      publish :search_fail, form.errors
    end
  end

  private
  def do_search(provider)
    results = provider.execute form.search
    
    if results.present?
      publish :search_success, results, form.search
    else
      publish :search_no_results, form.search
    end
  end
end