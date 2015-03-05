describe Occupation do
  describe '#initialize' do
    it 'initializes' do
      expect{ Occupation.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a experience' do
      expect(subject).to respond_to :experience
    end
  end
end
