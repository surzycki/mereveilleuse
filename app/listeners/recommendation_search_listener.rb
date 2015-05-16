class RecommendationSearchListener
  def initialize(context)
    @context = context
  end

  def search_success(results, search)
    RecommendationMailer.results(search, results).deliver_later  
  end

  def search_no_results(results)
    unless context.search.expanded?
      context.search_service.execute RecommendationExpandedSearchProvider.new
    end
  end

  private
  attr_reader :context
end