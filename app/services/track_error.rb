class TrackError
  def initialize(exception, logger=nil)
    Raygun.track_exception exception
    logger.error("EXCEPTION CAUGHT: #{exception}") if logger
  end
end