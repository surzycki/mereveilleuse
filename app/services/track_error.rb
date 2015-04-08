class TrackError
  def initialize(exception, env={})
    
    Airbrake.notify_or_ignore(
      exception,
      parameters: {},
      rack_env: env
    )
 
    Rails.logger.error("EXCEPTION CAUGHT: #{exception}")
  end
end