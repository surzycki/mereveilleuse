describe TrackError do
  subject { TrackError.new error, logger }
  
  let(:exception)  { spy ('error') }
  let(:env)        { spy ('env') }
    
  before do
    allow(Airbrake).to receive(:notify_or_ignore)
    allow(Rails).to receive_message_chain(:logger, :error)
  end

  describe 'initialize' do
    it 'initializes with exception and environemnt' do
      expect { TrackError.new exception, env }.to_not raise_error
    end 

    it 'initializes with no environment' do
      expect { TrackError.new exception }.to_not raise_error
    end  

    it 'errors without parameters' do
      expect { TrackError.new }.to raise_error
    end
  end

  describe 'tracking' do
    before {
      TrackError.new exception, env
    }

    it 'tracks exception with Airbrake' do
      expect(Airbrake).to have_received(:notify_or_ignore)
        .with exception, anything 
    end

    it 'log with logger' do
      expect(Rails.logger).to have_received(:error)
    end
  end
end