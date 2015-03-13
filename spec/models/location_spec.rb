describe Location do
  describe '#initialize' do
    it 'initializes' do
      expect{ Location.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has an street' do
      expect(subject).to respond_to :street
    end

    it 'has an city' do
      expect(subject).to respond_to :city
    end

    it 'has an postal_code' do
      expect(subject).to respond_to :postal_code
    end

    it 'has an country' do
      expect(subject).to respond_to :country
    end

    it 'has a latitude' do
      expect(subject).to respond_to :latitude
    end

    it 'has a longitude' do
      expect(subject).to respond_to :longitude
    end
  end

  describe 'associations' do
    it 'belongs to' do
      expect(subject).to belong_to(:locatable)
    end
  end

  describe '#address' do
    let(:subject)  { build_stubbed :location }
    
    it 'returns address' do
      address = "#{subject.street}, #{subject.postal_code}, #{subject.city}"
      expect(subject.address).to eq(address)
    end

    it 'returns address (no postal_code)' do
      subject.postal_code = ''

      address = "#{subject.street}, #{subject.city}"
      expect(subject.address).to eq(address)
    end

    it 'returns address (no city)' do
      subject.city = ''

      address = "#{subject.street}, #{subject.postal_code}"
      expect(subject.address).to eq(address)
    end
  end

  describe '#address=' do
    pending
  end
end
