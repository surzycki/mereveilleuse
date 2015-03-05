describe Profession do
  describe '#initialize' do
    it 'initializes' do
      expect{ Profession.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a name' do
      expect(subject).to respond_to :name
    end
  end
end
