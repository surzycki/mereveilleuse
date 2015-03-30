class RecommendationsEmailJob < ActiveJob::Base
  queue_as :default
 
  attr_reader :form

  def perform(search)
    @form = EmailSearchForm.new(search) 

    search_service.on :success do |results|
      # send email
      RecommendationMailer.results(search, results).deliver_later
      
      # reschedule email (env var temporary)
      RecommendationsEmailProvider.new(ENV['EMAIL_INTERVAL'].to_i.minutes).tap do |provider|
        provider.execute search
      end
    end

    search_service.on :fail do |errors|
      # Do nothing search has been canceled
    end

    search_service.execute RecommendationSearchProvider.new
  end

  private 
  def search_service
    @search_service ||= SearchService.new(form)
  end
end