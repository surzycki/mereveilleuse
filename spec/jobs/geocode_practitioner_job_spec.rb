# dependant on geocoder stubs
describe GeocodePractitionerJob do 
  subject { GeocodePractitionerJob.new }

  describe '#perform' do
    let(:practitioner) { build_stubbed :practitioner, :not_geocoded } 

    before do
      allow(practitioner).to receive(:save)
    end

    context 'when NOT geocoded' do
      before { subject.perform practitioner }

      it 'persists record' do
        expect(practitioner).to have_received(:save)
      end 

      it 'geocoded? returns true' do
        expect(practitioner.geocoded?).to be true
      end
    end
 
    context 'when geocoded' do
      let(:practitioner) { build_stubbed :practitioner }

      before { subject.perform practitioner }

      it 'does NOT persist record' do
        expect(practitioner).to_not have_received(:save)
      end 

      it 'geocoded? returns false' do
        expect(practitioner.geocoded?).to be true
      end
    end

    context 'when exception' do
      before do
        allow(practitioner).to receive(:address=).and_raise :error
        allow(TrackError).to receive(:new)
      
        subject.perform practitioner
      end

      it 'does NOT persist record' do
        expect(practitioner).to_not have_received(:save)
      end 

      it 'geocoded? returns false' do
        expect(practitioner.geocoded?).to be false
      end

      it 'tracks error' do
        expect(TrackError).to have_received(:new)
      end
    end
  end
end