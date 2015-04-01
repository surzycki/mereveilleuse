shared_examples 'it has location attributes' do
  # dependant upon geolocation stubs, address setting must match
  describe 'delegations' do
    it 'delegates address to location' do
      expect(subject).to delegate_method(:address).to(:location)
    end

    it 'delegates address to location allow nil' do
      expect(subject.address).to be_nil
    end

    it 'delegates short_address to location' do
      expect(subject).to delegate_method(:short_address).to(:location)
    end

    it 'delegates short_address to location allow nil' do
      expect(subject.short_address).to be_nil
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

    it 'delegates unparsed_address to location' do
      expect(subject).to delegate_method(:unparsed_address).to(:location)
    end

    it 'delegates unparsed_address to location allow nil' do
      expect(subject.unparsed_address).to be_nil
    end
  end

  describe 'associations' do
    it 'has one location' do
      expect(subject).to have_one(:location)
        .dependent(:destroy)
        .autosave(true)
    end
  end

  describe '#address=' do
    context 'when no location present' do
      let!(:subject) { described_class.create }

      it 'creates a location' do
        expect do
          subject.address = 'paris'
          subject.save
        end.to change(Location, :count).by(1)
      end

      it 'assigns address to location'  do
        expect do
          subject.address = 'paris'
          subject.save
        end.to change { subject.reload.address }
      end
    end

    context 'when location present' do
      let!(:subject) { create described_class.name.downcase.to_sym }

      it 'does NOT create a location' do
        expect do
          subject.address = 'paris'
          subject.save
        end.to_not change(Location, :count)
      end

      it 'assigns address to location' do
        expect do
          subject.address = 'paris'
          subject.save
        end.to change { subject.reload.address }
      end
    end
  end
end