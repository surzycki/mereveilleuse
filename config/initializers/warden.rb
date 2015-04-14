Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.default_strategies :facebook_javascript
  manager.scope_defaults :user, strategies: [:facebook_javascript, :token]
  
  manager.failure_app = lambda { |env| SessionsController.action(:fail).call(env) }
end

# Setup Session Serialization
Warden::Manager.serialize_into_session do |account|
  account.id
end

Warden::Manager.serialize_from_session do |id|
  User.find_by_id id
end

# Declare your strategies here
Warden::Strategies.add(:facebook_javascript) do
  def valid?
    params['token'].nil?
  end

  def authenticate!
    # TODO merge Authentication and FacbookAuthentication here
    # is parsing signed_request and authenticating
    
    # authentication is handled in FB
  end
end

Warden::Strategies.add(:token) do
  def valid?
    params['token']
  end

  def authenticate!
    # try user
    user = User.find_by(login_token: params[:token])

    if user
      success!(user)
    else
      halt!
    end
  end
end