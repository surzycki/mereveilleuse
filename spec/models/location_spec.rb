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
  end
end
