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

    it 'has a settings' do
      expect(subject).to respond_to :settings
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

  describe 'settings' do
    before do
      subject.settings[:search_alternatives] = '1,2,3'
    end

    it 'has search_alternatives settings' do
      expect(subject.settings).to eq ( { 'search_alternatives' => '1,2,3' } )
    end
  end
end
