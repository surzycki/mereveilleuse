describe NullOccupation do
  describe 'attributes' do
    it 'has a name' do
      expect(subject).to respond_to :name
    end

    it 'has a experience' do
      expect(subject).to respond_to :experience
    end

    it 'has an profession_id' do
      expect(subject).to respond_to :profession_id
    end
  end

  describe 'default values' do
    it 'has name not available' do
      expect(subject.name).to eq I18n.t('not_available')
    end

    it 'has experience zero' do
      expect(subject.experience).to eq 0
    end

    it 'has profession_id zero' do
      expect(subject.profession_id).to eq 0
    end
  end
end