describe Search do
  describe '#initialize' do
    it 'initializes' do
      expect{ Search.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a latitude' do
      expect(subject).to respond_to :latitude
    end

    it 'has a longitude' do
      expect(subject).to respond_to :longitude
    end

    it 'has a information' do
      expect(subject).to respond_to :information
    end

    it 'has a settings' do
      expect(subject).to respond_to :settings
    end

    it 'defines enum for status' do
      expect(subject).to define_enum_for(:status)
        .with [ :active, :canceled ]
    end
  end

  describe 'associations' do
    it 'has and belongs to many patient_types' do
      expect(subject).to have_and_belong_to_many(:patient_types)
    end

    it 'has and belongs to many professions' do
      expect(subject).to have_and_belong_to_many(:professions)
    end

    it 'belongs to user' do
      expect(subject).to belong_to(:user) 
    end

    it 'has one location' do
      expect(subject).to have_one(:location)
        .dependent(:destroy)
    end
  end

  describe 'settings' do
    before do
      subject.settings[:sent_practitioners] = '1,2,3'
    end

    it 'has sent_practitioners settings' do
      expect(subject.settings).to eq ( { 'sent_practitioners' => '1,2,3' } )
    end
  end
end