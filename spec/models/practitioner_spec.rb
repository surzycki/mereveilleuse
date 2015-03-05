describe Practitioner do
  describe '#initialize' do
    it 'initializes' do
      expect{ Practitioner.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a firstname' do
      expect(subject).to respond_to :firstname
    end

    it 'has a lastname' do
      expect(subject).to respond_to :lastname
    end

    it 'has an email' do
      expect(subject).to respond_to :email
    end

    it 'has a phone' do
      expect(subject).to respond_to :phone
    end

    it 'has mobile_phone' do
      expect(subject).to respond_to :mobile_phone
    end
  end
end
