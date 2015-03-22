class SearchResultsEmailJob < ActiveJob::Base
  queue_as :default
 
  attr_reader :form

  def perform(search)
    @form = EmailSearchForm.new(search) 

    search_service.on :success do |results|
      puts 'send email'
      puts 'reschedule job'
    end

    search_service.on :fail do |errors|
      puts errors
    end

    search_service.execute RecommendationSearchProvider.new

  end

  private 
  def search_service
    @search_service ||= SearchService.new(form)
  end
end