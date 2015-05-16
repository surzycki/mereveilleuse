describe RecommendationsEmailProvider do 
  subject { RecommendationsEmailProvider.new }

  let(:search)  { spy('search') }
 
  describe '#initialize' do
    it 'initializes with no params' do
      expect { RecommendationsEmailProvider.new }.to_not raise_error
    end

    it 'initializes with delay' do
      expect { RecommendationsEmailProvider.new }.to_not raise_error
    end

    it 'has default delay of 1s' do
      expect(subject.delay).to eq(1.second)
    end

    it 'sets delay of 30s' do
      subject = RecommendationsEmailProvider.new(30)
      expect(subject.delay).to eq(30.seconds)
    end
  end

  describe '#delay' do
    context 'when nil' do
      it 'returns default 60 seconds' do
        subject =  RecommendationsEmailProvider.new(nil)
        expect(subject.delay).to eq(60.seconds)
      end
    end

    context 'when string' do
      it 'returns seconds' do
        subject =  RecommendationsEmailProvider.new('90')
        expect(subject.delay).to eq(90.seconds)
      end
    end

    context 'when integer' do
      it 'returns seconds' do
        subject =  RecommendationsEmailProvider.new(120)
        expect(subject.delay).to eq(120.seconds)
      end
    end
  end

  describe '#execute' do
    let(:job)  { spy('job') }

    before do
      allow(RecurringRecommendationEmailJob).to receive(:set).and_return job
      subject.execute search
    end

    it 'queues RecurringRecommendationEmailJob with search' do
      expect(job).to have_received(:perform_later).
        with search
    end

    it 'returns empty hash' do
      expect(subject.execute search).to eq Hash.new
    end

    it 'sets wait time for queue' do
      expect(RecurringRecommendationEmailJob).to have_received(:set)
        .with hash_including(wait: subject.delay) 
    end
  end
end