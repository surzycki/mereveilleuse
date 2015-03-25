class DelayedEmailSearchProvider
  def execute(search)
    SearchResultsEmailJob.set(wait: 1.minutes).perform_later(search)
  end
end