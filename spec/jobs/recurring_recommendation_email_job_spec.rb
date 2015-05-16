describe RecurringRecommendationEmailJob do
  subject { RecurringRecommendationEmailJob.new }

  let(:search_service)  { spy('search_service') }
  let(:search_provider) { spy('search_provider') }
  let(:search)          { spy('search') }
  let(:listener)        { spy('listener') }
  let(:form)            { spy('form') }

  before do
    allow(SearchService).to receive(:new).and_return search_service
    allow(RecommendationSearchProvider).to receive(:new).and_return search_provider
    allow(EmailSearchForm).to receive(:new).and_return form
    allow(RecommendationSearchListener).to receive(:new).and_return listener
  end

  describe '#perform' do
    context 'success' do
      before do
        subject.perform search
      end

      it 'creates search service' do
        expect(SearchService).to have_received(:new)
          .with form
      end

      it 'intializes recommendation search listener' do
        expect(RecommendationSearchListener).to have_received(:new)
      end

      it 'executes search service with search provider' do
        expect(search_service).to have_received(:execute)
          .with search_provider
      end
    end

    context 'fail/cancel' do
      pending
    end

    context 'exception' do
      before do
        allow(TrackError).to receive(:new)
        allow(SearchService).to receive(:new).and_raise :error
        subject.perform search
      end

      it 'tracks error' do
        expect(TrackError).to have_received(:new)
      end
    end
  end
end