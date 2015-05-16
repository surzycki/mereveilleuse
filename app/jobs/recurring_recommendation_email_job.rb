class RecurringRecommendationEmailJob < ActiveJob::Base
  queue_as :default
 
  attr_reader :form, :search

  after_perform { |job| job.reschedule }

  def perform(search)
    @search = search
    @form   = EmailSearchForm.new(search) 

    search_service.subscribe(RecommendationSearchListener.new(self))

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

  def search_service
    @search_service ||= SearchService.new(form)
  end

  private 
  def interval
    ENV['EMAIL_INTERVAL'].to_i.seconds
  end
end