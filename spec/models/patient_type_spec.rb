describe PatientType do
  describe '#initialize' do
    it 'initializes' do
      expect{ PatientType.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a name' do
      expect(subject).to respond_to :name
    end
  end

  describe 'associations' do
    it 'has and belongs to many recommendations' do
      expect(subject).to have_and_belong_to_many(:recommendations)
    end

    it 'has and belongs to many searches' do
      expect(subject).to have_and_belong_to_many(:searches)
    end
  end
end
