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
  end
end
