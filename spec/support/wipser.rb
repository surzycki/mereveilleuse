require 'wisper/rspec/matchers'
require 'wisper/rspec/stub_wisper_publisher'

RSpec::configure do |config|
  config.include(Wisper::RSpec::BroadcastMatcher)
end