class Experiments
  class << self
    def client
      @client = Google::APIClient.new(
        application_name:    'mereveilleuse',
        application_version: '1.0.0'
      )
  
      key = Google::APIClient::KeyUtils.load_from_pkcs12(
        "#{Rails.root}/config/keys/google_service_account.p12", 'notasecret'
      )
  
      @client.authorization = Signet::OAuth2::Client.new(
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        audience:             'https://accounts.google.com/o/oauth2/token',
        scope:                'https://www.googleapis.com/auth/analytics.edit',
        issuer:               ENV['GOOGLE_SERVICE_ACCCOUNT'],
        signing_key:          key
      )
  
      @client.authorization.fetch_access_token!
  
      @client
    end
  
    def service
      @client.discovered_api('analytics', 'v3')
    end

    def setup(id)
      parameters = Experiments.parameters.merge(experimentId:  id)
        
      Experiments.client.execute(
        api_method: Experiments.service.management.experiments.patch,
        parameters: parameters, 
        body_object: { id: id, servingFramework: 'API' }
      )
    end

    def delete(id)
      parameters = Experiments.parameters.merge(experimentId:  id)
      
      Experiments.client.execute(
        api_method: Experiments.service.management.experiments.delete,
        parameters: parameters
      )
    end

    def parameters
      {
        accountId:     ENV['GOOGLE_ANALYTICS_ACCOUNT_ID'],
        webPropertyId: ENV['GOOGLE_ANALYTICS_TRACKING_ID'],
        profileId:     ENV['GOOGLE_ANALYTICS_PROFILE_ID']
      }
    end
  end

  attr_reader :id, :user_id, :raw_data

  def initialize(id:, user_id:)
    @id        = id
    @user_id   = user_id

    @raw_data  = get_experiment_data
  end

  def variation
    # returns original if experiment is not running
    return 0 unless is_running?
    
    user_variation || choose_variation
  end

  def is_running?
    raw_data['status'] == 'RUNNING'
  end

  def report
    <<-eos
      <script>
        ga('set', 'expId', "#{id}");
        ga('set', 'expVar', "#{variation}");
      </script>
    eos
    .html_safe
  end
  
  private
  def get_experiment_data
    
    return fetch("#{id}/raw_data") if fetch("#{id}/raw_data")
    
    parameters = Experiments.parameters.merge(experimentId:  id)
       
    response = Experiments.client.execute(
      api_method: Experiments.service.management.experiments.get,
      parameters: parameters
    )

    write("#{id}/raw_data", JSON.parse(response.body) )
  
    fetch("#{id}/raw_data")
  rescue Exception => e
    Hash.new
  end

  def fetch(cache_key)
    Rails.cache.fetch(cache_key)
  end

  def write(cache_key, value, expires = 1.hour)
    Rails.cache.write(cache_key, value, expires_in: expires )
  end

  def user_variation
    fetch("#{user_id}/#{id}")
  end

  def choose_variation
    random_spin        = rand()
    cumulative_weights = 0
    
    # set to original version
    result = 0

    raw_data['variations'].each_with_index do |variation, index|
      if variation['status'] == 'ACTIVE'
        cumulative_weights += variation['weight'].to_f
      end

      if random_spin < cumulative_weights
        result = index
        break
      end   
    end
    
    # save for user
    write("#{user_id}/#{id}", result, 10.days) if user_id

    result
  end
end