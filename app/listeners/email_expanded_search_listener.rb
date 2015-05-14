class EmailExpandedSearchListener
  def search_success(results, search)
    # no need to expand we have results
    
    return if results.present?

    search_provider = RecommendationSearchProvider.new
    
    # run the searches
    results = nil
    patient_types(search).each do |patient_type|
      # add expanded patient_type
      search.patient_types << patient_type
      # search
      response = search_provider.execute(search)
      # remove expanded patient_type
      search.patient_types.delete(patient_type)
      
      if response.present?
        results = response
        break
      end
    end
    
    # we have results, send them
    return if results.blank?
    # send email
    RecommendationMailer.results(search, results, true).deliver_later     
  end

  private
  def patient_types(search)
    # TODO put in expansion rule into patient_type model
    order = case search.patient_type_id
    when 1
      [2,5,4,3]
    when 2
      [1,5,4,3]
    when 3
      [4,5,1,2]
    when 4
      [3,5,1,2]
    else
      [2,1,4,3]
    end
    
    records = PatientType.find(order).group_by(&:id)
    order.map { |id| records[id].first }
  end
end