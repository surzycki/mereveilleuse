describe RecommendationService do
  subject { RecommendationService.new form }

  let(:form)            { spy('form') }
  let(:recommendation)  { spy('recommendation') }
  let(:errors)          { spy('errors') }

  describe '#initialize' do
    it 'initializes with form' do
      expect { RecommendationService.new form }.to_not raise_error
    end

    it 'errors without form' do
      expect { RecommendationService.new }.to raise_error
    end
  end

  describe '#create_recommendation' do
    context 'success' do
      before do
        allow(form).to receive(:process).and_return true
        allow(form).to receive(:recommendation).and_return recommendation
      end
      
      it 'broadcasts recommendation_created' do
        expect { 
          subject.create_recommendation
        }.to broadcast(:recommendation_created, recommendation)
      end
    end

    context 'fail' do
      before do
        allow(form).to receive(:process).and_return false
        allow(form).to receive(:errors).and_return errors
      end
      
      it 'broadcasts recommendation_create_fail' do
        expect { 
          subject.create_recommendation
        }.to broadcast(:recommendation_create_fail, errors)
      end
    end
  end
end