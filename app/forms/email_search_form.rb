class EmailSearchForm
  attr_accessor :search

  def initialize(search) 
    @search = search
  end

  def process   
    search.active?
  end

  def errors
    'not active, job canceled'
  end
end