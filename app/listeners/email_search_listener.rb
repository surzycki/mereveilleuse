class EmailSearchListener
  def search_success(results, search)
    # we have results, send them
    return if results.blank?
    # send email
    RecommendationMailer.results(search, results).deliver_later   
  end
end