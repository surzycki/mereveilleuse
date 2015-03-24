class GeocodePractitionerJob < ActiveJob::Base
  queue_as :default

  def perform(practitioner)
    return if practitioner.geocoded? 

    practitioner.address = practitioner.unparsed_address 
    practitioner.save
  rescue Exception => e
    TrackError.new e
  end
end