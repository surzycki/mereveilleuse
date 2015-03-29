class RecommendationsEmailProvider
  attr_reader :delay

  def initialize(delay = 1.seconds)
    @delay = delay
  end
  
  def execute(search)
    RecommendationsEmailJob.set(wait: delay).perform_later(search)
  end
end