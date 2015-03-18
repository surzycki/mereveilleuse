require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:suite) do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  config.before(:each) do
    # searchkick handshake when searchkick is instantiated
    stub_request(:get, /.*www.example.com:9200.*/).
      to_return(
        status: 200, 
        body: '{"status":200,"name":"mereveilleuse-stefan","version":{"number":"1.4.4","build_hash":"c88f77ffc81301dfa9dfd81ca2232f09588bd512","build_timestamp":"2015-02-19T13:05:36Z","build_snapshot":false,"lucene_version":"4.10.3"},"tagline":"You Know, for Search"}'
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