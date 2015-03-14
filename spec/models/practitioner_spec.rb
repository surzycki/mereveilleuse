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

    it 'delegates address to location' do
      expect(subject).to delegate_method(:address).to(:location)
    end

    it 'delegates address to location allow nil' do
      expect(subject.address).to be_nil
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

  describe 'scopes' do
    context 'find_by_fullname' do
      context 'successul' do
        before do
          allow(Practitioner).to receive(:find_by)
          Practitioner.find_by_fullname('Joe Blow')
        end

        it 'finds by firstname' do
          expect(Practitioner).to have_received(:find_by)
            .with hash_including(firstname: 'joe')
        end

        it 'finds by lastname' do
          expect(Practitioner).to have_received(:find_by)
            .with hash_including(lastname: 'blow')
        end
      end

      context 'not found' do
        it 'returns nil' do
          expect(Practitioner.find_by_fullname('Homer Simpson')).to be_nil
        end
      end

      context 'unrecognized input' do
        it 'single name returns nil' do
          expect(Practitioner.find_by_fullname('Simpson')).to be_nil
        end

        it 'blank returns nil' do
          expect(Practitioner.find_by_fullname('')).to be_nil
        end

        it 'nil returns nil' do
          expect(Practitioner.find_by_fullname).to be_nil
        end

        it 'strange returns nil' do
          expect(Practitioner.find_by_fullname('-- -')).to be_nil
        end
      end
    end
  end

  describe '#fullname=' do
    it 'parses standard names' do
      subject.fullname = 'Bob Jones'
      expect(subject.firstname).to eq 'Bob'
      expect(subject.lastname).to eq 'Jones'
    end

    it 'parses hyphenated names' do
      subject.fullname = 'Jean-Pierre Jones'
      expect(subject.firstname).to eq 'Jean Pierre'
      expect(subject.lastname).to eq 'Jones'
    end

    it 'parses compount names' do
      subject.fullname = 'Jean Pierre Jones'
      expect(subject.firstname).to eq 'Jean Pierre'
      expect(subject.lastname).to eq 'Jones'
    end
  end

  describe '#fullname' do
    it 'returns fullname' do
      expect(subject.fullname).to eq "#{subject.firstname} #{subject.lastname}"
    end
  end

  describe '#firstname' do
    it 'returns firstname capitalized' do
      practitioner = build_stubbed :practitioner, firstname: 'BOB'
      expect(practitioner.firstname).to eq 'Bob'
    end

    it 'no firstname returns nil' do
      practitioner = build_stubbed :practitioner, firstname: nil
      expect(practitioner.firstname).to be_nil
    end
  end

  describe '#lastname' do
    it 'returns lastname capitalized' do
      practitioner = build_stubbed :practitioner, lastname: 'JONES'
      expect(practitioner.lastname).to eq 'Jones'
    end

    it 'no lastname returns nil' do
      practitioner = build_stubbed :practitioner, lastname: nil
      expect(practitioner.lastname).to be_nil
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
    it 'returns occupation' do
      expect(subject.primary_occupation).to eq subject.occupations.first
    end
  end
end
