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
  end

  describe '#fullname=' do
    it 'parses standard names' do
      subject.fullname = 'Bob Jones'
      expect(subject.firstname).to eq 'Bob'
      expect(subject.lastname).to eq 'Jones'
    end

    it 'parses hyphenated names' do
      subject.fullname = 'Jean-Pierre Jones'
      expect(subject.firstname).to eq 'Jean-Pierre'
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

  describe '#add_occupation' do
    context 'when new occupation' do
      let(:subject)  { Practitioner.create }

      it 'creates new occupation' do
        expect do
          subject.add_occupation 1
        end.to change{ subject.occupations.count}.from(0).to(1)
      end
    end

    context 'when same occupation exists' do
      let(:subject)  { create :practitioner }
      
      it 'does NOT create occupation' do
        expect do
          subject.add_occupation 1
        end.to_not change{ subject.occupations.count }
      end
    end
  end

  describe '#primary_occupation' do
    it 'returns occupation' do
      expect(subject.primary_occupation).to eq subject.occupations.first
    end
  end
end
