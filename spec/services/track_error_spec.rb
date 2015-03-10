describe TrackError do
  subject { TrackError.new error, logger }
  
  let(:error)  { spy ('error') }
  let(:logger) {spy ('logger') }
  
  describe 'initialize' do
    it 'initializes with error and logger' do
      expect { TrackError.new error, logger }.to_not raise_error
    end  

    it 'errors without parameters' do
      expect { TrackError.new }.to raise_error
    end
  end

  describe 'tracking' do
    before do
      allow(Raygun).to receive(:track_exception)
      allow(logger).to receive(:error)

      TrackError.new error, logger
    end

    it 'tracks with Raygun' do
      expect(Raygun).to have_received(:track_exception)
        .with error
    end

    it 'log with logger' do
      expect(logger).to have_received(:error)
    end
  end
end