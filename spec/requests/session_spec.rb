describe 'session'  do
  describe 'create' do
    let(:facebook_auth)  { 
      OpenStruct.new(
        firstname:     'Bob',
        lastname:      'Hope',
        email:         'test@test.com',
        address:       'paris',
        facebook_id:   'facebook_id_123',
        profile_image: 'image.png',
        authenticated: true,
        platform:      'web'
    )}

    before do
      allow(FacebookAuthentication).to receive(:new).and_return facebook_auth
    end

    context 'new user' do
      context 'facebook authenticated' do
        it 'creates a user' do
          expect do
            post session_path, signed_request: 'facebook_signed_request'
          end.to change(User, :count).by(1)
        end
  
        it 'creates a location' do
          expect do
            post session_path, signed_request: 'facebook_signed_request'
          end.to change(Location, :count).by(1)
        end
  
        it 'authenticates user' do
          post session_path, signed_request: 'facebook_signed_request'    
          
          expect(controller.current_user).to be_a_kind_of(User)
        end
      end

      context 'NOT facebook authenticated' do
        before { facebook_auth.authenticated = false }
      
        it 'does NOT create a user' do
          expect do
            post session_path, signed_request: 'facebook_signed_request'
          end.to_not change(User, :count)
        end
  
        it 'does NOT create a location' do
          expect do
            post session_path, signed_request: 'facebook_signed_request'
          end.to_not change(Location, :count)
        end
        
        it 'does NOT authenticates user' do
          post session_path, signed_request: 'facebook_signed_request'    
          
          expect(controller.current_user).to be_nil
        end
      end      
    end

    context 'returning user' do
      let!(:user) { create :user }
      
      context 'NOT modified' do
        before do 
          facebook_auth.firstname   = user.firstname
          facebook_auth.lastname    = user.lastname
          facebook_auth.email       = user.email
          facebook_auth.facebook_id = user.facebook_id
        end
    
        it 'does NOT create a user' do
          expect do
           post session_path, signed_request: 'facebook_signed_request'
          end.to_not change(User, :count)
        end
  
        it 'does NOT create a location' do
          expect do
            post session_path, signed_request: 'facebook_signed_request'
          end.to_not change(Location, :count)
        end
  
        it 'authenticates user' do
          post session_path, signed_request: 'facebook_signed_request'    
        
          expect(controller.current_user).to be_a_kind_of(User)
        end
      end

      context 'modified' do
        before do 
          facebook_auth.firstname   = user.firstname
          facebook_auth.lastname    = user.lastname
          facebook_auth.email       = 'new.email@example.com'
          facebook_auth.facebook_id = user.facebook_id
        end

        it 'does NOT create a user' do
          expect do
           post session_path, signed_request: 'facebook_signed_request'
          end.to_not change(User, :count)
        end
  
        it 'does NOT create a location' do
          expect do
            post session_path, signed_request: 'facebook_signed_request'
          end.to_not change(Location, :count)
        end

        it 'authenticates user' do
          post session_path, signed_request: 'facebook_signed_request'    
        
          expect(controller.current_user).to be_a_kind_of(User)
        end

        it 'updates email' do
          expect do
            post session_path, signed_request: 'facebook_signed_request'
          end.to change { user.reload.email }.to('new.email@example.com')
        end
      end
    end

    context 'fail/exception' do
      let(:facebook_auth)  { spy('facebook_auth' ) }

      before do
        allow(User).to receive(:find_or_create_by).and_raise :error
      end

      it 'does NOT create a user' do
        expect do
          post session_path, signed_request: 'facebook_signed_request'
        end.to_not change(User, :count)
      end

      it 'does NOT create a location' do
        expect do
          post session_path, signed_request: 'facebook_signed_request'
        end.to_not change(Location, :count)
      end
      
      it 'does NOT authenticates user' do
        post session_path, signed_request: 'facebook_signed_request'    
        
        expect(controller.current_user).to be_nil
      end
    end

    context 'user with bad address' do
      before { facebook_auth.address = 'bad address' }
      
      it 'creates a user' do
        expect do
          post session_path, signed_request: 'facebook_signed_request'
        end.to change(User, :count).by(1)
      end

      it 'does NOT create a location' do
        expect do
          post session_path, signed_request: 'facebook_signed_request'
        end.to_not change(Location, :count)
      end

      it 'authenticates user' do
        post session_path, signed_request: 'facebook_signed_request'    
        
        expect(controller.current_user).to be_a_kind_of(User)
      end
    end

    context 'unsubscribed user returning' do
      pending
    end
  end
end