class RecommendationsEmailProvider
  
  def initialize(delay = 1)
    @delay = delay
  end
  
  def delay
    return 60.seconds if @delay.nil?
    
    @delay.to_i.seconds
  end

  def execute(search)
    RecurringRecommendationEmailJob.set(wait: delay).perform_later(search)
    
    # return empty results as they are defered
    Hash.new
  end
end