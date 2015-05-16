class RecommendationExpandedSearchProvider
  attr_reader :search, :results

  def execute(search)
    @search = search

    perform_search
  rescue Exception => e
    TrackError.new e
  end

  def perform_search
    # use the regular search provider
    search_provider = RecommendationSearchProvider.new

    # run the searches
    expanded_patient_types(search).each do |patient_type|
      # add expanded patient_type
      search.patient_types << patient_type
      # perform the search with the provider
      response = search_provider.execute(search)
      # remove expanded patient_type
      search.patient_types.delete(patient_type)
      # break if we have results
      if response.present?
        @results = response
        break
      end
    end

    # mark search as expanded
    search.expanded!

    @results
  end

  private
  def expanded_patient_types(search)
    # get alternative possibilities for the patient_type
    order = search.patient_type.search_alternatives.split(',')
    # extract the actual records
    records = PatientType.find(order).group_by(&:id)
    order.map { |id| records[id.to_i].first }
  end
end
