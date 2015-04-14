describe Federation, focus: true do
  describe '#initialize' do
    it 'initializes' do
      expect{ described_class.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a name' do
      expect(subject).to respond_to :name
    end
  end

  describe 'associations' do
    it 'has and belongs to many practitioners' do
      expect(subject).to have_and_belong_to_many(:practitioners)
    end
  end
end
