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

  describe 'delegations' do
    it 'delegates address to practitioner' do
      expect(subject).to delegate_method(:address).to(:practitioner)
    end

    it 'delegates latitude to practitioner' do
      expect(subject).to delegate_method(:latitude).to(:practitioner)
    end

    it 'delegates longitude to practitioner' do
      expect(subject).to delegate_method(:longitude).to(:practitioner)
    end
  end

  describe '#coordinates' do
    it 'return lat/long' do
      subject = build_stubbed :recommendation

      expect(subject.coordinates).to eq [ subject.latitude, subject.longitude ]
    end
  end

  describe '#rating' do
    it 'calculates a rating' do
      subject.wait_time       = 2
      subject.availability    = 2
      subject.bedside_manner  = 4
      subject.efficacy        = 4
      
      expect(subject.rating).to be 3.0
    end 
  end

  describe '#search_data', focus: true do
    let(:subject)  { build_stubbed :recommendation }
  
    it 'has location' do
      expect(subject.search_data).to include(location: subject.coordinates)
    end

    it 'has profession_id' do
      expect(subject.search_data).to include(profession_id: subject.profession_id)
    end

    it 'has patient_type_ids' do
      expect(subject.search_data).to include(patient_type_ids: subject.patient_types.map(&:id) )
    end

    it 'has practitioner_id' do
      expect(subject.search_data).to include(practitioner_id: subject.practitioner.id )
    end
  end

  describe '#should_index?' do
    it 'indexes when state completed' do
      subject = build_stubbed :recommendation
      

      expect(subject.should_index?).to eq true
    end

    it 'does NOT index when state NOT completed' do
      subject = build_stubbed :recommendation
      subject.state = 'step_one'

      expect(subject.should_index?).to eq false
    end
  end
end
