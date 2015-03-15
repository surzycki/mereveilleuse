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

  describe '#short_address' do
    let(:subject)  { build_stubbed :location }
    
    it 'returns short_address' do
      short_address = "#{subject.city}, #{subject.postal_code}"
      expect(subject.short_address).to eq(short_address)
    end

    it 'returns short_address (no postal_code)' do
      subject.postal_code = ''

      short_address = "#{subject.city}"
      expect(subject.short_address).to eq(short_address)
    end

    it 'returns short_address (no city)' do
      subject.city = ''

      short_address = "#{subject.postal_code}"
      expect(subject.short_address).to eq(short_address)
    end
  end

  describe '#address=' do
    pending
  end
end
