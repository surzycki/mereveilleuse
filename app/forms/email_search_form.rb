class EmailSearchForm
  include ActiveModel::Model
  
  attr_accessor :search

  def initialize(search) 
    @search = search
  end

  def process   
    search.active?
  end

  def errors
    OpenStruct.new(full_messages: ['not active, job canceled'])
  end
end