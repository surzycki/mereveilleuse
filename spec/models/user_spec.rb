describe User do
  describe '#initialize' do
    it 'initializes' do
      expect{ User.new }.to_not raise_error
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

    it 'has a facebook_id' do
      expect(subject).to respond_to :facebook_id
    end

    it 'has has_invited' do
      expect(subject).to respond_to :has_invited
    end

    it 'has status' do
      expect(subject).to respond_to :status
    end

    it 'defines enum for status' do
      expect(subject).to define_enum_for(:status)
        .with [ :unregistered, :registered ]
    end
  end

  describe 'associations' do
    it 'has many recommendations' do
      expect(subject).to have_many(:recommendations)
        .dependent(:destroy)
    end

    it 'has many referals through recommendations' do
      expect(subject).to have_many(:referals)
        .through(:recommendations)
        .source(:practitioner)
    end

    it 'has many recommendations' do
      expect(subject).to have_many(:recommendations)
        .dependent(:destroy)
    end

    it 'has one location' do
      expect(subject).to have_one(:location)
        .dependent(:destroy)
    end
  end

  describe 'context' do
    context 'before_save' do
      let(:user) { create :user }

      before do
        allow_any_instance_of(User).to receive(:normalize_name)
          .and_call_original
      end

      it 'calls normalize_name' do
        expect(user).to have_received(:normalize_name)
      end

      it 'downcases firstname' do
        user.firstname = 'BOB'
        user.save

        expect(user.read_attribute(:firstname)).to eq('bob')
      end

      it 'downcases lastname' do
        user.lastname = 'HOPE'
        user.save
        
        expect(user.read_attribute(:lastname)).to eq('hope')
      end
    end
  end

  describe '#firstname' do
    it 'returns firstname capitalized' do
      user = build_stubbed :user, firstname: 'BOB'
      expect(user.firstname).to eq 'Bob'
    end

    it 'no firstname returns nil' do
      user = build_stubbed :user, firstname: nil
      expect(user.firstname).to be_nil
    end
  end

  describe '#lastname' do
    it 'returns lastname capitalized' do
      user = build_stubbed :user, lastname: 'JONES'
      expect(user.lastname).to eq 'Jones'
    end

    it 'no lastname returns nil' do
      user = build_stubbed :user, lastname: nil
      expect(user.lastname).to be_nil
    end
  end

  describe '#fullname' do
    it 'returns fullname' do
      expect(subject.fullname).to eq "#{subject.firstname} #{subject.lastname}"
    end
  end
end
