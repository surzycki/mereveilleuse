describe SessionsController do
  let(:facebook_authentication)  { spy('facebook_authentication') }
  let(:warden)                   { spy('warden') }
  let(:user)                     { spy('user') }
  let(:error)                    { spy('error') }
  let(:authentication_service)   { wisper_spy('authentication_service') }

  before do
    allow(AuthenticationService).to  receive(:new).and_return authentication_service
    allow(FacebookAuthentication).to receive(:new).and_return facebook_authentication
    allow(controller).to receive(:warden).and_return warden
  end

  describe 'GET new' do
    context 'in production' do
      before do 
        allow(Rails.env).to receive(:production?).and_return true
        get :new 
      end

      it 'returns http redirect' do
        expect(response).to be_redirect
      end

      it 'does NOT authenticate' do
        expect(authentication_service).to_not have_received(:authenticate)
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end
    end

    context 'NOT in production' do
      before do
        allow(User).to receive(:first).and_return user
        mock_wisper_publisher(authentication_service, :authenticate, :success, user)
        get :new
      end

      it 'does authenticates' do
        expect(authentication_service).to have_received(:authenticate) 
      end
    end
  end

  describe 'POST create' do
    context 'handle authenticity token' do
      before {
        mock_wisper_publisher(authentication_service, :authenticate, :success, user) 
      }

      it 'skips authenticity token' do
        allow(controller).to receive (:verify_authenticity_token)
        post :create, signed_request: '1234', fb_locale: 'en_US'

        expect(controller).to_not have_received(:verify_authenticity_token)
      end
    end

    context 'success'  do
      context 'with REGISTERED user' do
        before do
          mock_wisper_publisher(authentication_service, :authenticate, :login, user)
          allow(user).to receive(:registered?).and_return true
          
          post :create, signed_request: '1234', fb_locale: 'en_US'
        end
        
        it 'sets warden user' do
          expect(warden).to have_received(:set_user)
            .with user, scope: :user
        end

        it 'returns http redirect' do
          expect(response).to be_redirect
        end

        it 'redirects to new search path' do
          expect(response).to redirect_to new_search_path
        end

        it 'authentications with facebook' do
          expect(FacebookAuthentication).to have_received(:new)
            .with '1234', nil
        end
  
        it 'inits authentication_service' do
          expect(AuthenticationService).to have_received(:new)
        end
  
        it 'authentications with app' do
          expect(authentication_service).to have_received(:authenticate)
            .with facebook_authentication
        end
      end

      context 'with REGISTERED user REDIRECTED' do
        before do
          mock_wisper_publisher(authentication_service, :authenticate, :login, user, '/redirect_path')
          allow(user).to receive(:registered?).and_return true
          
          post :create, signed_request: '1234', fb_locale: 'en_US', app_data: '/redirect_path'
        end

        it 'sets warden user' do
          expect(warden).to have_received(:set_user)
            .with user, scope: :user
        end

        it 'returns http redirect' do
          expect(response).to be_redirect
        end

        it 'redirects to redirect_path' do
          expect(response).to redirect_to '/redirect_path'
        end

        it 'authentications with facebook' do
          expect(FacebookAuthentication).to have_received(:new)
            .with '1234', '/redirect_path'
        end
  
        it 'inits authentication_service' do
          expect(AuthenticationService).to have_received(:new)
        end
  
        it 'authentications with app' do
          expect(authentication_service).to have_received(:authenticate)
            .with facebook_authentication
        end
      end

      context 'with UNREGISTERED user' do
        before do
          mock_wisper_publisher(authentication_service, :authenticate, :signup, user)
          allow(user).to receive(:registered?).and_return false
          
          post :create, signed_request: '1234', fb_locale: 'en_US'
        end

        it 'sets warden user' do
          expect(warden).to have_received(:set_user)
            .with user, scope: :user
        end

        it 'returns http redirect' do
          expect(response).to be_redirect
        end

        it 'redirects to new registration path' do
          expect(response).to redirect_to new_registration_path
        end

        it 'authentications with facebook' do
          expect(FacebookAuthentication).to have_received(:new)
            .with '1234', nil
        end
  
        it 'inits authentication_service' do
          expect(AuthenticationService).to have_received(:new)
        end
  
        it 'authentications with app' do
          expect(authentication_service).to have_received(:authenticate)
            .with facebook_authentication
        end
      end

      context 'with NEW user' do
        before do
          mock_wisper_publisher(authentication_service, :authenticate, :request_authentication, facebook_authentication)
          
          post :create, signed_request: '1234', fb_locale: 'en_US', app_data: '/redirect_path'
        end

        it 'returns http redirect' do
          expect(response).to be_redirect
        end

        it 'redirects to new registration path' do
          expect(response).to redirect_to new_registration_path(requesting_authentication: true)
        end
      end
    end

    context 'fail' do
      before do
        mock_wisper_publisher(authentication_service, :authenticate, :fail, error)
        allow(TrackError).to receive(:new)

        post :create, signed_request: '1234', fb_locale: 'en_US'
      end

      it 'does NOT set warden user' do
        expect(warden).to_not have_received(:set_user)
      end

      it 'returns http redirect' do
        expect(response).to be_redirect
      end

      it 'redirects to not_found_path path' do
        expect(response).to redirect_to not_found_path
      end

      it 'tracks error' do
        expect(TrackError).to have_received(:new)
          .with error, anything
      end
    end

    context 'exception' do
      before do
        allow(AuthenticationService).to receive(:new).and_raise :error
        allow(TrackError).to receive(:new)

        post :create, signed_request: '1234', fb_locale: 'en_US'
      end

      it 'returns http redirect' do
        expect(response).to be_redirect
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end

      it 'tracks error' do
        expect(TrackError).to have_received(:new)
      end
    end 
  end 
end
