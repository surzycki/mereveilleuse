describe Practitioner do
  it_behaves_like 'a person with a name'
  it_behaves_like 'a model with a location'

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

  describe 'callbacks' do
    context 'after_initialize' do
      it 'call set_uuid' do
        allow_any_instance_of(Practitioner).to receive(:set_uuid)
        expect(Practitioner.new).to have_received(:set_uuid)
      end
    end

    context 'before_save' do
      let(:practitioner) { create :practitioner }

      before do
        allow_any_instance_of(Practitioner).to receive(:normalize_name)
          .and_call_original
      end

      it 'calls normalize_name' do
        expect(practitioner).to have_received(:normalize_name)
      end

      it 'downcases firstname' do
        practitioner.firstname = 'BOB'
        practitioner.save

        expect(practitioner.read_attribute(:firstname)).to eq('bob')
      end

      it 'downcases lastname' do
        practitioner.lastname = 'HOPE'
        practitioner.save
        
        expect(practitioner.read_attribute(:lastname)).to eq('hope')
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
end
