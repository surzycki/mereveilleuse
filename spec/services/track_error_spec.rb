describe TrackError do
  subject { TrackError.new error, logger }
  
  let(:exception)  { spy ('error') }
  let(:logger)     { spy ('logger') }
    
  before do
    allow(logger).to receive(:error)
    allow(Airbrake).to receive(:notify_or_ignore)
    allow(ENV).to receive(:to_hash)
  end

  describe 'initialize' do
    it 'initializes with error and logger' do
      expect { TrackError.new exception, logger }.to_not raise_error
    end  

    it 'errors without parameters' do
      expect { TrackError.new }.to raise_error
    end
  end

  describe 'tracking' do
    before {
      TrackError.new exception, logger
    }

    it 'tracks env with Airbrake' do
      expect(ENV).to have_received(:to_hash)
    end

    it 'tracks exception with Airbrake' do
      expect(Airbrake).to have_received(:notify_or_ignore)
        .with exception, anything 
    end

    it 'log with logger' do
      expect(logger).to have_received(:error)
    end
  end
end