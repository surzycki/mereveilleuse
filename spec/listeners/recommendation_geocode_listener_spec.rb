describe RecommendationGeocodeListener do
  let(:subject)        { RecommendationGeocodeListener.new }
  let(:recommendation) { build_stubbed :recommendation }
  
  describe '#initialize' do
    it 'initializes' do
      expect { RecommendationGeocodeListener.new }.to_not raise_error
    end
  end 

  describe '#geocode' do
    before do
      allow(GeocodePractitionerJob).to receive(:perform_later)
      subject.geocode(recommendation)
    end

    it 'queues practitioner geocode job' do
      expect(GeocodePractitionerJob).to have_received(:perform_later)
    end
  end
end