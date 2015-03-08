Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.default_strategies :facebook_canvas
  manager.failure_app = lambda { |env| SessionsController.action(:on_authentication_fail).call(env) }
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
    account = User.find_by_id env['user_id']
    
    if account 
      success! account
    else 
      fail 'login fail'
    end
  end
end