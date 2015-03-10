describe Recommendation do
  describe '#initialize' do
    it 'initializes' do
      expect{ Recommendation.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a wait_time' do
      expect(subject).to respond_to :wait_time
    end

    it 'has a availability' do
      expect(subject).to respond_to :availability
    end

    it 'has an bedside_manner' do
      expect(subject).to respond_to :bedside_manner
    end

    it 'has a efficacy' do
      expect(subject).to respond_to :efficacy
    end

    it 'has comment' do
      expect(subject).to respond_to :comment
    end

    it 'has state' do
      expect(subject).to respond_to :state
    end

    it 'has state default value' do
      expect(subject.state).to eq 'step_one'
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      expect(subject).to belong_to(:user)
    end

    it 'belongs to practitioner' do
      expect(subject).to belong_to(:practitioner)
    end

    it 'has and belongs to many patient_types' do
      expect(subject).to have_and_belong_to_many(:patient_types)
    end
  end
end
