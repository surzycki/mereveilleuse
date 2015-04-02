class GeocodeListener
  def recommendation(recommendation)
    practitioner = recommendation.practitioner
    GeocodePractitionerJob.perform_later practitioner
  end
end