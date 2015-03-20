describe Recommendation do
  describe '#initialize' do
    it 'initializes' do
      expect{ Recommendation.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a wait_time' do
      expect(subject).to respond_to :wait_time
    end

    it 'has a availability' do
      expect(subject).to respond_to :availability
    end

    it 'has an bedside_manner' do
      expect(subject).to respond_to :bedside_manner
    end

    it 'has a efficacy' do
      expect(subject).to respond_to :efficacy
    end

    it 'has comment' do
      expect(subject).to respond_to :comment
    end

    it 'has state' do
      expect(subject).to respond_to :state
    end

    it 'has state default value' do
      expect(subject.state).to eq 'step_one'
    end

  end

  describe 'associations' do
    it 'belongs to user' do
      expect(subject).to belong_to(:user)
    end

    it 'belongs to practitioner' do
      expect(subject).to belong_to(:practitioner)
    end

    it 'belongs_to profession' do
      expect(subject).to belong_to(:profession)
    end

    it 'has and belongs to many patient_types' do
      expect(subject).to have_and_belong_to_many(:patient_types)
    end
  end

  describe '#latitude' do
    it 'returns 0 with no pracitioner' do
      expect(subject.latitude).to eq 0
    end

    it 'return latitude' do
      subject = build_stubbed :recommendation, :completed
      
      expect(subject.latitude).to eq subject.practitioner.latitude
    end
  end

  describe '#longitude' do
    it 'returns 0 with no pracitioner' do
      expect(subject.longitude).to eq 0
    end

    it 'return longitude' do
      subject = build_stubbed :recommendation, :completed
      
      expect(subject.longitude).to eq subject.practitioner.longitude
    end
  end

  describe '#coordinates' do
    it 'return lat/long' do
      subject = build_stubbed :recommendation, :completed

      expect(subject.coordinates).to eq [ subject.latitude, subject.longitude ]
    end
  end

  describe '#search_data' do
    let(:subject)  { build_stubbed :recommendation, :completed }
  
    it 'has coordinates' do
      expect(subject.search_data).to include(coordinates: subject.coordinates)
    end

    it 'has profession_id' do
      expect(subject.search_data).to include(profession_id: subject.profession_id)
    end

    it 'has patient_type_ids' do
      expect(subject.search_data).to include(patient_type_ids: subject.patient_types.map(&:id) )
    end
  end

  describe '#should_index?' do
    it 'indexes when state completed' do
      subject = build_stubbed :recommendation, :completed

      expect(subject.should_index?).to eq true
    end

    it 'does NOT index when state step one' do
      subject = build_stubbed :recommendation
      
      expect(subject.should_index?).to eq false
    end

    it 'does NOT index when state step two' do
      subject = build_stubbed :recommendation, :step_two
      
      expect(subject.should_index?).to eq false
    end
  end
end
