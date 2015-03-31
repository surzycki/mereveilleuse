class TrackError
  def initialize(exception, logger=nil)
    Airbrake.notify_or_ignore(
      exception,
      parameters: {},
      cgi_data: ENV.to_hash
    )
 
    logger.error("EXCEPTION CAUGHT: #{exception}") if logger
  end
end