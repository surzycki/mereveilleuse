describe RecurringRecommendationEmailJob do
  subject { RecurringRecommendationEmailJob.new }

  let(:search_service)  { spy('search_service') }
  let(:search_provider) { spy('search_provider') }
  let(:form)            { spy('email_search_form') }
  let(:listener)        { spy('generic_listener')}
  let(:search)          { spy('search') }

  before do
    allow(EmailSearchForm).to receive(:new).and_return form
    allow(SearchService).to receive(:new).and_return search_service
    allow(RecommendationSearchProvider).to receive(:new).and_return search_provider
    
    allow(EmailSearchListener).to receive(:new).and_return listener
    allow(EmailExpandedSearchListener).to receive(:new).and_return listener
  end

  describe '#perform' do
    context 'success' do
      before do
        subject.perform search
      end

      it 'creates new search form' do
        expect(EmailSearchForm).to have_received(:new)
          .with search
      end
  
      it 'creates search service' do
        expect(SearchService).to have_received(:new)
          .with form
      end

      it 'intializes email search listener' do
        expect(EmailSearchListener).to have_received(:new)
      end

      it 'intializes expanded search listener' do
        expect(EmailExpandedSearchListener).to have_received(:new)
      end

      it 'has search_service subscribed to success events' do
        expect(search_service).to have_received(:subscribe)
          .with(listener, hash_including(on: :search_success))
          .twice
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