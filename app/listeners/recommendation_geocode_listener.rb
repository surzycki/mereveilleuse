class RecommendationGeocodeListener
  def geocode(recommendation)
    practitioner = recommendation.practitioner
    GeocodePractitionerJob.perform_later practitioner
  end
end