describe Profession do
  describe '#initialize' do
    it 'initializes' do
      expect{ Profession.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a name' do
      expect(subject).to respond_to :name
    end

    it 'has a status' do
      expect(subject).to respond_to :status
    end

    it 'defines enum for status' do
      expect(subject).to define_enum_for(:status)
        .with [ :not_indexed, :indexed ]
    end
  end

  describe 'associations' do
    it 'has many occupations' do
      expect(subject).to have_many(:occupations)
    end 

    it 'has many practitioners' do
      expect(subject).to have_many(:practitioners)
        .through(:occupations)
    end 

    it 'has and belongs to many searches' do
      expect(subject).to have_and_belong_to_many(:searches)
    end
  end

  describe '#search_data' do
    let(:subject)  { build_stubbed :profession }

    it 'has name' do
      expect(subject.search_data).to include(name: subject.name)
    end
  end

  describe '#should_index?' do
    it 'indexes when status indexed' do
      subject = build_stubbed :profession

      expect(subject.should_index?).to eq true
    end

    it 'does NOT index when status not_indexed' do
      subject = build_stubbed :profession, status: Profession.statuses[:not_indexed] 
      
      expect(subject.should_index?).to eq false
    end
  end
end
