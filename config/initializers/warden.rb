Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.default_strategies :facebook_canvas
  manager.scope_defaults :user, strategies: [:facebook_canvas]
  
  manager.failure_app   = lambda { |env| SessionsController.action(:on_authentication_fail).call(env) }
end

# Setup Session Serialization
Warden::Manager.serialize_into_session do |account|
  account.id
end

Warden::Manager.serialize_from_session do |id|
  User.find_by_id id
end

# Declare your strategies here
Warden::Strategies.add(:facebook_canvas) do
  def authenticate!
    # TODO merge Authentication and FacbookAuthentication here
    # is parsing signed_request and authenticating
    
    # authentication is handled in FB
  end
end