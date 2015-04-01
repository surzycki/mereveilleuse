describe Practitioner do
  it_behaves_like 'it has person name attributes'
  it_behaves_like 'it has location attributes'

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

    it 'has uuid' do
      expect(subject).to respond_to :uuid
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

    it 'has many recommenders through recommendations' do
      expect(subject).to have_many(:recommenders)
        .through(:recommendations)
        .source(:recommender)
        .class_name('User')
    end

    it 'has one location' do
      expect(subject).to have_one(:location)
        .dependent(:destroy)
    end

    it 'has and belongs to many insurances' do
      expect(subject).to have_and_belong_to_many(:insurances)
    end

    it 'has and belongs to many federations' do
      expect(subject).to have_and_belong_to_many(:federations)
    end
  end

  describe 'callbacks' do
    context 'after_initialize' do
      it 'call set_uuid' do
        allow_any_instance_of(Practitioner).to receive(:set_uuid)
        expect(Practitioner.new).to have_received(:set_uuid)
      end
    end
    
    context 'before_save' do
      let(:subject) { create :practitioner } 

      before { allow(subject).to receive(:reindex_recommendations) }  
      
      context 'location changed' do  
        before do
          subject.address = 'france'
          subject.save
        end

        it 'reindexs recommendations' do
          expect(subject).to have_received(:reindex_recommendations)
        end
      end

      context 'location NOT changed' do
        before do
          subject.save
        end

        it 'does NOT reindex recommedations' do
          expect(subject).to_not have_received(:reindex_recommendations)
        end
      end
    end
  end

  describe '#add_occupation' do
    context 'new practitioner' do
      let(:subject) { Practitioner.new }
      
      it 'creates occupation' do
        subject.add_occupation 1

        expect do
          subject.save
        end.to change(Occupation, :count).by(1)
      end
    end

    context 'existing practitioner' do
      context 'new occupation' do
        let(:subject)    { Practitioner.create }
      
        it 'creates occupation' do
          subject.add_occupation 10

          expect do
            subject.save  
          end.to change(Occupation, :count).by(1)
        end
      end

      context 'existing occupation' do  
        let(:subject) { create :practitioner }

        it 'does NOT creates occupation' do
          subject.add_occupation subject.primary_occupation.profession_id

          expect do
            subject.save
          end.to_not change(Occupation, :count)
        end
      end
    end
  end

  describe '#primary_occupation' do
    let(:subject)  { build_stubbed :practitioner }

    it 'returns occupation' do
      expect(subject.primary_occupation).to eq subject.occupations.first
    end

    context 'no occupation' do
      let(:subject) { Practitioner.new }

      it 'returns null occupation' do
        expect(subject.primary_occupation).to be_a(NullOccupation)
      end
    end
  end

  describe '#search_data' do
    let(:subject)  { build_stubbed :practitioner }

    it 'has fullname' do
      expect(subject.search_data).to include(fullname: subject.fullname)
    end

    it 'has firstname' do
      expect(subject.search_data).to include(firstname: subject.firstname)
    end

    it 'has lastname' do
      expect(subject.search_data).to include(lastname: subject.lastname)
    end
  end

  describe '#should_index?' do
    it 'indexes when status indexed' do
      subject = build_stubbed :practitioner

      expect(subject.should_index?).to eq true
    end

    it 'does NOT index when status not_indexed' do
      subject = build_stubbed :practitioner, status: Practitioner.statuses[:not_indexed] 
      
      expect(subject.should_index?).to eq false
    end
  end

  describe '#location_changed?' do
    let(:subject) { create :practitioner }
    
    context 'when location changed' do 
      it 'returns true' do
        subject.address = 'france'
        expect(subject.location_changed?).to be true
      end
    end

    context 'when location NOT changed' do 
      it 'returns false' do
        expect(subject.location_changed?).to be false
      end
    end

    context 'when nil location' do 
      let(:subeject) { Practitioner.new }

      it 'returns false' do
        expect(subject.location_changed?).to be false
      end
    end
  end

  describe '#geocoded?' do
    context 'when location geocoded' do
      let(:subject)  { build_stubbed :practitioner }

      it 'returns true' do
        expect(subject.geocoded?).to be true
      end
    end

    context 'when location NOT geocoded' do
      let(:subject)  { build_stubbed :practitioner, :not_geocoded }
    
      it 'returns false' do
        expect(subject.geocoded?).to be false
      end
    end

    context 'when location nil' do
      it 'returns false' do
        expect(subject.geocoded?).to be false
      end
    end
  end

  describe '#contact_phone' do
    context 'when mobile and fixed present' do
      let(:subject) { build_stubbed :practitioner }
      
      it 'returns mobile number' do
        expect(subject.contact_phone).to eq subject.mobile_phone
      end
    end

    context 'when fixed is nil' do
      let(:subject) { build_stubbed :practitioner, phone: nil }
      
      it 'returns mobile number' do
        expect(subject.contact_phone).to eq subject.mobile_phone
      end
    end

    context 'when fixed is blank' do
      let(:subject) { build_stubbed :practitioner, phone: '' }
      
      it 'returns mobile number' do
        expect(subject.contact_phone).to eq subject.mobile_phone
      end
    end

    context 'when mobile nil' do
      let(:subject) { build_stubbed :practitioner, mobile_phone: nil }
      
      it 'returns fixed number' do
        expect(subject.contact_phone).to eq subject.phone
      end
    end

    context 'when mobile blank' do
      let(:subject) { build_stubbed :practitioner, mobile_phone: '' }
      
      it 'returns fixed number' do
        expect(subject.contact_phone).to eq subject.phone
      end
    end

    context 'when both are nil' do
      let(:subject) { build_stubbed :practitioner, mobile_phone: nil, phone: nil }
      
      it 'returns nil' do
        expect(subject.contact_phone).to be_nil
      end
    end

    context 'when both are blank' do
      let(:subject) { build_stubbed :practitioner, mobile_phone: '', phone: '' }
      
      it 'returns nil' do
        expect(subject.contact_phone).to be_nil
      end
    end
  end
end
