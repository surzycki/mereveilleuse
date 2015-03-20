shared_examples 'a model with a location' do
  describe 'delegations' do
    it 'delegates address to location' do
      expect(subject).to delegate_method(:address).to(:location)
    end

    it 'delegates address to location allow nil' do
      expect(subject.address).to be_nil
    end

    it 'delegates latitude to location' do
      expect(subject).to delegate_method(:latitude).to(:location)
    end

    it 'delegates latitude to location allow nil' do
      expect(subject.latitude).to be_nil
    end

    it 'delegates longitude to location' do
      expect(subject).to delegate_method(:longitude).to(:location)
    end

    it 'delegates longitude to location allow nil' do
      expect(subject.longitude).to be_nil
    end
  end
end