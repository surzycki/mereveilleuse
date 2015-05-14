class RecurringRecommendationEmailJob < ActiveJob::Base
  queue_as :default
 
  attr_reader :form, :search

  after_perform { |job| job.reschedule }

  def perform(search)
    @search = search
    @form   = EmailSearchForm.new(search) 

    search_service.subscribe( EmailSearchListener.new )
    search_service.subscribe( EmailExpandedSearchListener.new )
  
    search_service.execute RecommendationSearchProvider.new
  rescue Exception => e
    TrackError.new(e)
  end

  def reschedule
    # to prevent infinite looks in integration testing
    return if Rails.env.test?

    unless search.canceled? 
      self.class.set(wait: interval).perform_later(search)
    end
  end

  private 
  def search_service
    @search_service ||= SearchService.new(form)
  end

  def interval
    ENV['EMAIL_INTERVAL'].to_i.seconds
  end
end