describe RecommendationForm do
  subject { RecommendationForm.new Recommendation.new, practitioner }

  let(:practitioner)    { build_stubbed :practitioner }
  let(:recommendation)  { subject.recommendation}
  
  describe '#initialize' do
    it 'initializes with recommendation and practitioner' do
      expect { RecommendationForm.new Recommendation.new, practitioner }.to_not raise_error
    end

    it 'implicit initialization of practitioner' do
      allow(Practitioner).to receive(:new)
      RecommendationForm.new Recommendation.new
      expect(Practitioner).to have_received(:new)
    end

    it 'implicit initialization of recommendation' do
      allow(Recommendation).to receive(:new)
      RecommendationForm.new 
      expect(Recommendation).to have_received(:new)
    end
  end

  describe 'attributes' do
    it 'has a practitioner' do 
      expect(subject).to respond_to :practitioner
    end

    it 'has a practitioner_name' do 
      expect(subject).to respond_to :practitioner_name
    end

    it 'has a user_id' do
      expect(subject).to respond_to :user_id
    end

    it 'has a patient_type_id' do 
      expect(subject).to respond_to :patient_type_id
    end

    it 'has a profession_id' do 
      expect(subject).to respond_to :profession_id
    end

    it 'has a address' do 
      expect(subject).to respond_to :address
    end

    it 'has a wait_time' do 
      expect(subject).to respond_to :wait_time
    end

    it 'has a availability' do 
      expect(subject).to respond_to :availability
    end

    it 'has a bedside_manner' do 
      expect(subject).to respond_to :bedside_manner
    end

    it 'has a efficacy' do 
      expect(subject).to respond_to :efficacy
    end

    it 'has a comment' do 
      expect(subject).to respond_to :comment
    end

    it 'has a state' do
      expect(subject).to respond_to :state
    end    
  end

  describe 'validations' do
    context 'step one' do
      before { subject.state = 'step_one' }

      it 'validates presense of practitioner_name' do
        expect(subject).to validate_presence_of :practitioner_name
      end

      it 'validates presense of user_id' do
        expect(subject).to validate_presence_of :user_id
      end

      it 'validates presense of patient_type_id' do
        expect(subject).to validate_presence_of :patient_type_id
      end

      it 'validates presense of profession_id' do
        expect(subject).to validate_presence_of :profession_id
      end

      it 'validates presense of address' do
        expect(subject).to validate_presence_of :address
      end
    end

    context 'step two' do
      before { subject.state = 'step_two' }

      it 'validates presense of wait_time' do
        expect(subject).to validate_presence_of :wait_time
      end

      it 'validates presense of availability' do
        expect(subject).to validate_presence_of :availability
      end

      it 'validates presense of bedside_manner' do
        expect(subject).to validate_presence_of :bedside_manner
      end

      it 'validates presense of efficacy' do
        expect(subject).to validate_presence_of :efficacy
      end

      it 'validates presense of comment' do
        expect(subject).to validate_presence_of :comment
      end
    end
  end

  describe 'state machine' do
    context 'new form' do
      it 'starts with step_one' do
        expect(subject.state).to eq 'step_one'
      end
  
      it 'transitions to step_two' do
        expect(subject.next_step_transition.to).to eq 'step_two'
      end
    end

    context 'step two' do
      it 'transitions to completed ' do
        subject.state = 'step_two'
        expect(subject.next_step_transition.to).to eq 'completed'
      end
    end
  end

  describe 'transition callbacks' do
    context 'before transition' do
      context 'with valid form' do
        before do
          allow(subject).to receive(:valid?).and_return true
          allow(subject).to receive(:save)
          subject.next_step
        end
        
        it 'checks form validity' do
          expect(subject).to have_received(:valid?)
        end

        it 'saves the form' do
          expect(subject).to have_received(:save)
        end
      end

      context 'with INVALID form' do
        before do
          allow(subject).to receive(:valid?).and_return false
          allow(subject).to receive(:save)
          subject.next_step
        end
        
        it 'checks form validity' do
          expect(subject).to have_received(:valid?)
        end

        it 'does NOT save the form' do
          expect(subject).to_not have_received(:save)
        end
      end
    end

    context 'after transition' do
      before do
        allow(subject).to receive(:save)
        allow(recommendation).to receive(:save)
      end

      context 'when valid' do
        before do
          allow(subject).to receive(:valid?).and_return true
          
          subject.next_step
        end
        
        it 'saves recommendation state' do
          expect(recommendation).to have_received(:save)
        end
      end

      context 'with INVALID form' do
        before do
          allow(subject).to receive(:valid?).and_return false
          
          subject.next_step
        end

        it 'does NOT save recommendation state' do
          expect(recommendation).to_not have_received(:save)
        end
      end
    end
  end

  describe '#save' do
    context 'exception' do
      before do
        allow(recommendation).to receive(:attributes=).and_raise :error 
      end

      it 'returns false' do
        expect(subject.save).to be false
      end
    end
  end
end