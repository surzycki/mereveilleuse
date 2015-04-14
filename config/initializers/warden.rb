Rails.configuration.middleware.use Warden::Manager do |manager|
  # defined in devise otherwise wokiness and hilarlity ensues bc active admin
  # uses devise and devise uses warden
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
    user = User.authenticate_with_token params[:token]

    if user
      success!(user)
    else
      redirect! config[:redirect_url]
    end
  end

  def config
    env['warden'].config[:scope_defaults][:user]
  end
end