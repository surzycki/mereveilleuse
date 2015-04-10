describe User do
  it_behaves_like 'it has person name attributes'
  it_behaves_like 'it has location attributes'

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

    it 'has a profile image' do
      expect(subject).to respond_to :profile_image
    end

    it 'has a friend_count' do
      expect(subject).to respond_to :friend_count
    end

    it 'has a verified' do
      expect(subject).to respond_to :verified
    end

    it 'defines enum for status' do
      expect(subject).to define_enum_for(:status)
        .with [ :unregistered, :registered, :unsubscribed ]
    end

    it 'defines enum for platform' do
      expect(subject).to define_enum_for(:platform)
        .with [ :canvas, :web ]
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

    it 'has many searches' do
      expect(subject).to have_many(:searches)
        .dependent(:destroy)
    end
  end

  describe '#unsubscribe' do
    let(:subject)  { build_stubbed :user }  
    let(:search)   { spy('search') }
    let(:searches) { [search] }

    before do
      allow(subject).to receive(:searches).and_return searches
      allow(subject).to receive(:unsubscribed!)

      subject.unsubscribe
    end

    it 'cancels searches' do
      expect(search).to have_received(:canceled!).once
    end

    it 'sets status to unsubscribed' do
      expect(subject).to have_received(:unsubscribed!).once
    end
  end
end
