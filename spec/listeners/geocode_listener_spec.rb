describe GeocodeListener do
  let(:subject)        { GeocodeListener.new }
  let(:recommendation) { build_stubbed :recommendation }
  
  describe '#initialize' do
    it 'initializes' do
      expect { GeocodeListener.new }.to_not raise_error
    end
  end 

  describe '#recommendation' do
    before do
      allow(GeocodePractitionerJob).to receive(:perform_later)
      subject.recommendation(recommendation)
    end

    it 'queues practitioner geocode job' do
      expect(GeocodePractitionerJob).to have_received(:perform_later)
    end
  end
end