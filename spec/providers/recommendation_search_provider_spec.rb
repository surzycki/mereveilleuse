describe RecommendationSearchProvider do
  subject { RecommendationSearchProvider.new }

  let(:search)   { spy('search') }
  let(:results)  { spy('results') }

  describe '#initialize' do
    it 'initializes with no params' do
      expect { RecommendationSearchProvider.new }.to_not raise_error
    end
  end

  describe '#execute' do
    context 'success' do
      before do
        allow(Recommendation).to receive(:search).and_return results
        
        subject.execute search
      end

      it 'performs search' do
        expect(Recommendation).to have_received(:search)
      end
  
      it 'saves sent practitioners' do
        expect(search).to have_received(:sent_practitioners=)
      end

      it 'retrieves sent practitioners' do
        expect(search).to have_received(:sent_practitioners).at_least(:once)
      end

      it 'returns results' do
        expect(subject.execute search).to eq results
      end      
    end

    context 'failure' do
      before do
        allow(Recommendation).to receive(:search).and_raise :error
        allow(TrackError).to receive(:new)

        subject.execute search
      end

      it 'returns empty hash' do
        expect(subject.execute search).to eq Hash.new
      end
  
      it 'tracks the error' do
        expect(TrackError).to have_received(:new)
      end
    end
  end
end