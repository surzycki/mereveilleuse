describe FacebookAuthentication do 
  let(:subject)           { FacebookAuthentication.new(cookies: cookies) }

  let(:cookies)           { spy('cookies') }
  let(:signed_request)    { spy('signed_request') }
  let(:user_info)         { spy('user_info') }
  let(:oauth)             { spy('facebook_oauth') }
  let(:facebook_api)      { spy('facebook_api') }
  
  let(:app_data)          { 'app_data' }
  let(:profile_image)     { 'http://facebook.com/profile/image' }
  let(:friend_count)      { 10 }

  let(:facebook_me) { 
    {
      'id': '111111111', 
      'first_name': 'Bob',
      'email': 'test@example.com', 
      'last_name': 'Hope', 
      'location': {
        'id': '110774245616525', 
        'name': 'Paris, France'
      },
      'verified': true
    }
  }

  before do
    allow(Koala::Facebook::OAuth).to receive(:new).and_return oauth
    allow(Koala::Facebook::API).to   receive(:new).and_return facebook_api
    
    allow(oauth).to receive(:get_user_info_from_cookies).and_return user_info
    allow(facebook_api).to receive(:get_object).and_return facebook_me
    allow(facebook_api).to receive(:get_picture).and_return profile_image
    
    allow(facebook_api).to receive_message_chain(:get_connections, :raw_response, :[], :[]).and_return friend_count
  end

  describe '#initialize' do
    it 'initializes with arguments' do
      expect do 
        FacebookAuthentication.new(
          cookies:        cookies,
          app_data:       app_data,
          signed_request: signed_request
        )
      end.to_not raise_error
    end

    it 'initializes with cookies and app_data' do
      expect do 
        FacebookAuthentication.new(
          cookies:        cookies,
          app_data:       app_data
        )
      end.to_not raise_error
    end

     it 'initializes with cookies' do
      expect do 
        FacebookAuthentication.new(
          cookies:        cookies
        )
      end.to_not raise_error
    end

    it 'errors without cookies' do
      expect do 
        FacebookAuthentication.new(
          app_data:       app_data,
          signed_request: signed_request
        )
      end.to raise_error
    end
  end

  describe 'attributes' do
    it 'has cookies' do
      expect(subject).to respond_to :cookies
    end

    it 'has a platform' do
      expect(subject).to respond_to :platform
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

    it 'has profile image' do
      expect(subject).to respond_to :profile_image
    end

    it 'has a redirect_path' do
      expect(subject).to respond_to :redirect_path
    end

    it 'has a verified' do
      expect(subject).to respond_to :verified
    end

    it 'has a friend_count' do
      expect(subject).to respond_to :friend_count
    end
  end

  describe 'authentication' do
    context 'when success' do
      it 'is authenticated' do
        expect(subject.authenticated).to be true
      end

      it 'sets platform' do
        expect(subject.platform).to eq 'web'
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

      it 'sets profile_image' do
        expect(subject.profile_image).to eq profile_image
      end 

      it 'set verified' do
        expect(subject.verified).to eq true
      end

      it 'set friend_count' do
        expect(subject.friend_count).to eq friend_count
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

      context 'no verified' do
        let(:facebook_me) { 
          {
            'id': '111111111', 
            'first_name': 'Bob',
            'last_name': 'Hope',
            'email': 'test@example.com'
          }
        }

        it 'sets verified to false' do 
          expect(subject.verified).to be false
        end
      end
    end

    context 'when NO friend_list permission' do
      before do
        allow(facebook_api).to receive_message_chain(:get_connections).and_return []
      end

      it 'is authenticated' do
        expect(subject.authenticated).to be true
      end

      it 'sets friend_count to 0' do
        expect(subject.friend_count).to eq 0
      end
    end

    context 'when app_data' do
      let(:subject) { FacebookAuthentication.new(cookies: cookies, app_data: app_data) }
      
      it 'sets redirect_path from app_data' do
        expect(subject.redirect_path).to eq app_data
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
        allow(oauth).to receive(:get_user_info_from_cookies).and_raise :exception
      end

      it 'is NOT authenticated' do
        expect(subject.authenticated).to be false
      end
    end

    context 'when login from web' do
      it 'is authenticated' do
        expect(subject.authenticated).to be true
      end

      it 'sets platform' do
        expect(subject.platform).to eq 'web'
      end
    end

    context 'when login fom canvas' do
      let(:subject)  { FacebookAuthentication.new(cookies: cookies, signed_request: signed_request) }

      it 'is authenticated' do
        expect(subject.authenticated).to be true
      end

      it 'sets platform' do
        expect(subject.platform).to eq 'canvas'
      end
    end
  end 
end