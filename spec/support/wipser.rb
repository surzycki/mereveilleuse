require 'wisper/rspec/matchers'
require 'wisper/rspec/stub_wisper_publisher'

module WisperMockHelper
  class WisperSpy < RSpec::Mocks::Double
    include Wisper::Publisher
  
    def metaclass
      class << self; self; end
    end

    def __broadcast(event_to_publish, *published_event_args)
      publish event_to_publish, *published_event_args
    end
  end

  def wisper_spy(object)
    WisperSpy.new(object).as_null_object 
  end

  def mock_wisper_publisher(mock, called_method, event_to_publish, *published_event_args)
    allow(mock).to receive(called_method) { 
      mock.__broadcast(event_to_publish, *published_event_args) 
    }
  end
end

RSpec::configure do |config|
  config.include Wisper::RSpec::BroadcastMatcher
  config.include WisperMockHelper
end