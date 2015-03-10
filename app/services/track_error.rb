class TrackError
  def initialize(exception, logger)
    Raygun.track_exception exception
    logger.error("EXCEPTION CAUGHT: #{exception}")
  end
end