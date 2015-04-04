describe RecommendationsEmailJob do
  subject { RecommendationsEmailJob.new }

  let(:search_service)  { wisper_spy('search_service') }
  let(:search_provider) { spy('recommendation_search_provider') }
  let(:email_provider)  { spy('recommendation_email_provider') }
  let(:form)            { spy('email_search_form') }
  let(:search)          { spy('search') }
  let(:results)         { spy('results') }

  before do
    allow(EmailSearchForm).to receive(:new).and_return form
    allow(SearchService).to receive(:new).and_return search_service
    allow(RecommendationSearchProvider).to receive(:new).and_return search_provider
    allow(RecommendationsEmailProvider).to receive(:new).and_return email_provider
  
    allow(RecommendationMailer).to receive_message_chain(:results, :deliver_later)
  end

  describe '#perform' do
    context 'success' do
      before do
        mock_wisper_publisher(search_service, :execute, :search_success, results, search)
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
  
      it 'executes search service with search provider' do
        expect(search_service).to have_received(:execute)
          .with search_provider
      end

      it 'creates mail' do
        expect(RecommendationMailer).to have_received(:results)
          .with(search,results)
      end

      it 'sends mail (queue)' do
        expect(RecommendationMailer.results).to have_received(:deliver_later)
      end

      it 'reschedules email with delay' do
        expect(RecommendationsEmailProvider).to have_received(:new)
          .with ENV['EMAIL_INTERVAL']
      end
    end

    context 'fail/cancel' do
      before do
        mock_wisper_publisher(search_service, :execute, :search_fail, {})
        subject.perform search
      end

      it 'deos NOT create mail' do
        expect(RecommendationMailer).to_not have_received(:results)
      end

      it 'does NOT send mail (queue)' do
        expect(RecommendationMailer.results).to_not have_received(:deliver_later)
      end

      it 'does NOT reschedule email' do
         expect(email_provider).to_not have_received(:execute)
      end
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