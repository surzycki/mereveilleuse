describe FacebookAuthentication do 
  let(:subject)           { FacebookAuthentication.new signed_request }

  let(:signed_request)    { spy('signed_request') }
  let(:validated_request) { spy('validated_request') }
  
  let(:oauth)             { spy('facebook_oauth') }
  let(:facebook_api)      { spy('facebook_api') }
  let(:facebook_me) { 
    {
      'id': '111111111', 
      'first_name': 'Bob',
      'email': 'test@example.com', 
      'last_name': 'Hope', 
      'location': {
        'id': '110774245616525', 
        'name': 'Paris, France'
      }
    }
  }

  before do
    allow(Koala::Facebook::OAuth).to receive(:new).and_return oauth
    allow(Koala::Facebook::API).to   receive(:new).and_return facebook_api
    
    allow(oauth).to receive(:parse_signed_request).and_return validated_request
    allow(facebook_api).to receive(:get_object).and_return facebook_me
  end

  describe '#initialize' do
    it 'initializes with signed_request' do
      expect { FacebookAuthentication.new(signed_request) }.to_not raise_error
    end

    it 'errors without signed_request' do
      expect { FacebookAuthentication.new }.to raise_error
    end
  end

  describe 'attributes' do
    it 'has a signed_request' do
      expect(subject).to respond_to :signed_request
    end

    it 'has a firstname' do
      expect(subject).to respond_to :firstname
    end

    it 'has a lastname' do
      expect(subject).to respond_to :lastname
    end

    it 'has a email' do
      expect(subject).to respond_to :email
    end

    it 'has a facebook_id' do
      expect(subject).to respond_to :facebook_id
    end

    it 'has a address' do
      expect(subject).to respond_to :address
    end
   
    it 'has a authenticated' do
      expect(subject).to respond_to :authenticated
    end
  end

  describe 'authentication' do
    context 'when success' do
      it 'is authenticated' do
        expect(subject.authenticated).to be true
      end

      it 'sets firstname' do
        expect(subject.firstname).to eq 'Bob'
      end

      it 'sets lastname' do
        expect(subject.lastname).to eq 'Hope'
      end

      it 'sets email' do
        expect(subject.email).to eq 'test@example.com'
      end

      it 'sets facebook_id' do
        expect(subject.facebook_id).to eq '111111111'
      end

      it 'sets address' do
        expect(subject.address).to eq 'Paris, France'
      end 

      context 'no location' do
        let(:facebook_me) { 
          {
            'id': '111111111', 
            'first_name': 'Bob',
            'last_name': 'Hope',
            'email': 'test@example.com'
          }
        }
        
        it 'doesn NOT set address' do
          expect(subject.address).to be nil
        end
      end   
    end

    context 'when fail' do
      before do
        allow(Koala::Facebook::API).to receive(:new).and_raise :exception
      end

      it 'is NOT authenticated' do
        expect(subject.authenticated).to be false
      end
    end

    context 'when exception' do
      before do
        allow(oauth).to receive(:parse_signed_request).and_raise :exception
      end

      it 'is NOT authenticated' do
        expect(subject.authenticated).to be false
      end
    end
  end 
end