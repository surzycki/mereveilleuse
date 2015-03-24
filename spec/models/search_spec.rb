describe Search do
  it_behaves_like 'it has location attributes'

  describe '#initialize' do
    it 'initializes' do
      expect{ Search.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a information' do
      expect(subject).to respond_to :information
    end

    it 'has a settings' do
      expect(subject).to respond_to :settings
    end

    it 'has a md5_hash' do
      expect(subject).to respond_to :md5_hash
    end

    it 'defines enum for status' do
      expect(subject).to define_enum_for(:status)
        .with [ :active, :canceled ]
    end
  end

  describe 'associations' do
    it 'has and belongs to many patient_types' do
      expect(subject).to have_and_belong_to_many(:patient_types)
    end

    it 'has and belongs to many professions' do
      expect(subject).to have_and_belong_to_many(:professions)
    end

    it 'belongs to user' do
      expect(subject).to belong_to(:user) 
    end
  end

  describe 'callbacks' do
    context 'after_validation' do
      let(:subject)  { build_stubbed :search }

      before { subject.valid? }

      it 'creates the correct hash' do
        string = "#{subject.status}-#{subject.patient_types.map(&:id)}-#{subject.professions.map(&:id)}-#{subject.address}-#{subject.user.try(:id)}"
      
        expect(subject.md5_hash).to eq Digest::MD5.hexdigest(string)
      end

      it 'changes hash with attributes' do
        old_hash       = subject.md5_hash
        subject.status = Search.statuses[:canceled]
        
        subject.valid? 
        expect(subject.md5_hash).to_not eq old_hash
      end
    end
  end

  describe 'settings' do
    before do
      subject.settings[:sent_practitioners] = '1,2,3'
    end

    it 'has sent_practitioners settings' do
      expect(subject.settings).to eq ( { 'sent_practitioners' => '1,2,3' } )
    end
  end
end