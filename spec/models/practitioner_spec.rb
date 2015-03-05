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

  describe 'associations' do
    it 'has many occupations' do
      expect(subject).to have_many(:occupations)
        .dependent(:destroy)
        .autosave(true)
    end

    it 'has many professions through occupations' do
      expect(subject).to have_many(:professions)
        .through(:occupations)
    end


    it 'has many recommendations' do
      expect(subject).to have_many(:recommendations)
        .dependent(:destroy)
    end

    it 'has many references through recommendations' do
      expect(subject).to have_many(:references)
        .through(:recommendations)
        .source(:user)
    end

    it 'has one location' do
      expect(subject).to have_one(:location)
        .dependent(:destroy)
    end
  end
end
