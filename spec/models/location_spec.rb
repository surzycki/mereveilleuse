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
      expect(subject.address).to eq(address.titleize)
    end

    it 'returns address (no postal_code)' do
      subject.postal_code = ''

      address = "#{subject.street}, #{subject.city}"
      expect(subject.address).to eq(address.titleize)
    end

    it 'returns address (no city)' do
      subject.city = ''

      address = "#{subject.street}, #{subject.postal_code}"
      expect(subject.address).to eq(address.titleize)
    end
  end

  describe '#short_address' do
    let(:subject)  { build_stubbed :location }
    
    it 'returns short_address' do
      short_address = "#{subject.city}, #{subject.postal_code}"
      expect(subject.short_address).to eq(short_address.titleize)
    end

    it 'returns short_address (no postal_code)' do
      subject.postal_code = ''

      short_address = "#{subject.city}"
      expect(subject.short_address).to eq(short_address.titleize)
    end

    it 'returns short_address (no city)' do
      subject.city = ''

      short_address = "#{subject.postal_code}"
      expect(subject.short_address).to eq(short_address.titleize)
    end
  end

  describe '#address=' do
    let(:address_parser) { spy('address parser') }
    
    before do
      allow(AddressParser).to receive(:new).and_return(address_parser)
      allow(subject).to receive(:save)

      subject.address = 'address'
    end
    
    it 'parses the address' do
      expect(AddressParser).to have_received(:new)
        .with('address')
    end

    it 'saves' do
      expect(subject).to have_received(:save)
    end

    it 'it sets attributes to parsed values' do 
      expect(address_parser).to have_received(:set)
        .with subject
    end
  end
end
