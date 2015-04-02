class RecommendationsEmailProvider
  
  def initialize(delay = 1)
    @delay = delay
  end
  
  def delay
    return 60.seconds if @delay.nil?
    
    @delay.to_i.seconds
  end

  def execute(search)
    RecommendationsEmailJob.set(wait: delay).perform_later(search)
  end
end