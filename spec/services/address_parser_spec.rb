describe AddressParser do 
  # uses stubbed geocoder see spec/support/geocoder.rb
  let(:subject) { AddressParser.new('paris') } 

  describe '#initialize' do
    it 'initializes with address' do
      expect { AddressParser.new('paris') }.to_not raise_error
    end

    it 'errors without address' do
      expect { AddressParser.new }.to raise_error
    end
  end 

  describe 'attributes' do
    it 'has an street' do
      expect(subject).to respond_to :street
    end

    it 'has a city' do
      expect(subject).to respond_to :city
    end

    it 'has a postal_code' do
      expect(subject).to respond_to :city
    end

    it 'has a department' do
      expect(subject).to respond_to :department
    end

    it 'has a region' do
      expect(subject).to respond_to :region
    end

    it 'has a country' do
      expect(subject).to respond_to :region
    end
  
    it 'has a latitude' do
      expect(subject).to respond_to :latitude
    end

    it 'has a longitude' do
      expect(subject).to respond_to :longitude
    end    
  end

  describe 'sets attributes' do
    context 'generic (city)' do
      it 'sets a city' do
        expect(subject.city).to eq('Paris')
      end

      it 'sets a postal_code' do
        expect(subject.postal_code).to eq(nil)
      end
  
      it 'sets a department' do
        expect(subject.department).to eq('Paris')
      end

      it 'sets a region' do
        expect(subject.region).to eq('Île-de-France')
      end
  
      it 'sets a country' do
        expect(subject.country).to eq('France')
      end
  
      it 'sets a latitude' do
        expect(subject.latitude).to eq(42.2)
      end
  
      it 'sets a longitude' do
        expect(subject.longitude).to eq(2.2)
      end
    end

    context 'street' do
      context 'when no street' do
        it 'returns nil' do
          ['france','ile de france','paris','75011'].each do |location|
            subject = AddressParser.new(location)
            expect(subject.street).to be nil
          end
        end
      end

      context 'when street' do
        it 'returns correct street' do
          subject = AddressParser.new('6 rue gobert paris france')
          expect(subject.street).to eq('6 Rue Gobert')
        end
      end
    end
  end

  describe 'exception' do
    it 'throws an exception' do
      expect{ AddressParser.new('blurg blurg') }.to raise_error(NameError)
    end
  end
end