class RecommendationsEmailJob < ActiveJob::Base
  queue_as :default
 
  attr_reader :form

  def perform(search)
    @form = EmailSearchForm.new(search) 

    search_service.on :search_success do |results, search|
      # send email
      RecommendationMailer.results(search, results).deliver_later
      # reschedule email (env var temporary)
      provider = RecommendationsEmailProvider.new(ENV['EMAIL_INTERVAL'])
      
      provider.execute search
    end

    search_service.execute RecommendationSearchProvider.new
  rescue Exception => e
    TrackError.new(e)
  end

  private 
  def search_service
    @search_service ||= SearchService.new(form)
  end
end