describe RecommendationForm, focus: true do
  subject { RecommendationForm.new recommendation }
  
  let(:recommendation) { Recommendation.new }

  describe '#initialize' do
    it 'initializes with recommendation' do
      expect { RecommendationForm.new recommendation }.to_not raise_error
    end

    it 'errors without recommendation' do
      expect { RecommendationForm.new }.to raise_error
    end
  end

  describe 'attributes' do
    it 'has a practitioner' do 
      expect(subject).to respond_to :practitioner
    end

    it 'has a patient_type' do 
      expect(subject).to respond_to :patient_type
    end

    it 'has a profession' do 
      expect(subject).to respond_to :profession
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
      it 'transitions to step_three ' do
        subject.state = 'step_two'
        expect(subject.next_step_transition.to).to eq 'step_three'
      end
    end

    context 'entering step_three' do
      it 'transitions to completed' do
        subject.state = 'step_three'
        expect(subject.next_step_transition.to).to eq 'completed'
      end
    end
  end

  describe 'transitions' do
  end

  describe 'form_fields' do
    context 'step_one' do
      it 'has form fields' do
        expect(subject.form_fields).to eq [:practitioner, :patient_type, :profession, :address]
      end
    end

    context 'step_two' do
      it 'has form fields' do
        subject.state = 'step_two'
        expect(subject.form_fields).to eq [:wait_time, :availability, :bedside_manner, :efficacy, :comment]
      end
    end

    context 'step_three' do
      
    end
  end
end