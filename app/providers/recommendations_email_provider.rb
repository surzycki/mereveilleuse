class RecommendationsEmailProvider
  def execute(search)
    RecommendationsEmailJob.set(wait: 1.minutes).perform_later(search)
  end
end