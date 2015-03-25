class RecommendationSearchProvider
  attr_reader :search

  def execute(search)
    @search = search
    results = perform_search
    byebug
    # save unique sent_practitioners to search so we don't send the same practitioners
    @search.sent_practitioners = (@search.sent_practitioners + results.map(&:practitioner_id)).uniq
    @search.save
  
    results
  rescue Exception => e
    TrackError.new e
    # return empty results so we try again later
    Hash.new
  end

  def perform_search
    
    Recommendation.search( '*', { 
      where: { 
        location: { near: [ search.latitude, search.longitude ], within: '60km' },
        profession_id: search.professions.map(&:id).join(','),
        patient_type_ids: search.patient_types.map(&:id),
        practitioner_id: { not: search.sent_practitioners }
      },

      order: { 
        rating: 'desc',
        _geo_distance: { 
          location: "#{search.latitude}, #{search.longitude}", order: 'asc', unit: 'km' 
        } 
      },

      page: 1, per_page: 1
    }).results
  end
end
