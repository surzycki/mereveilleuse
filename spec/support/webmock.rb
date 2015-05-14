require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:suite) do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  config.before(:each) do
    # searchkick handshake when searchkick is instantiated
    handshake_response = File.open('spec/fixtures/json/elasticsearch/handshake_response.json').read
    stub_request(:get, /^www.example.com:9200$/).
      to_return(
        status: 200, 
        body: handshake_response
      )
    
    # Search recommendations with default query (patient_type: 1) and return a recommendation
    recommendation_defaut_query = File.open('spec/fixtures/json/elasticsearch/recommendation_default_query.json').read
    recommendation_response     = File.open('spec/fixtures/json/elasticsearch/recommendation_response.json').read
    
    stub_request(:get, "http://www.example.com:9200/mereveilleuse-test_recommendations_test/_search").
      with(body: recommendation_defaut_query).
      to_return(
        headers: { 'Content-Type' => 'application/json' },
        status: 200, 
        body: recommendation_response
      )

    # Search recommendations with secondary query (patient_type: 2) and return no recommendations
    recommendation_secondary_query = File.open('spec/fixtures/json/elasticsearch/recommendation_secondary_query.json').read
    recommendation_empty_response  = File.open('spec/fixtures/json/elasticsearch/recommendation_empty_response.json').read
    
    stub_request(:get, "http://www.example.com:9200/mereveilleuse-test_recommendations_test/_search").
      with(body: recommendation_secondary_query).
      to_return(
        headers: { 'Content-Type' => 'application/json' },
        status: 200, 
        body: recommendation_empty_response
      )


    stub_request(:put, /.*www.example.com:9200.*/).
      to_return(
        status: 200
      )

    stub_request(:delete, /.*www.example.com:9200.*/).
      to_return(
        status: 200
      )
  end

  config.after(:suite) do
    WebMock.allow_net_connect!
  end
end