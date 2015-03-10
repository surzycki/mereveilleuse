describe SessionsController do
  
  describe 'POST index' do
    let(:facebook_authentication)  { spy('facebook_authentication') }
    let(:authentication)           { spy('authentication') }
    
    before do
      allow(FacebookAuthentication).to receive(:new).and_return facebook_authentication
      allow(Authentication).to         receive(:new).and_return authentication 
    end

    context 'success' do
      before do
        post :index, signed_request: '1234', fb_locale: 'en_US'
      end

      it 'authentications with facebook' do
        expect(FacebookAuthentication).to have_received(:new)
          .with '1234'
      end

      it 'inits authentication' do
        expect(Authentication).to have_received(:new)
      end

      it 'authentications with app' do
        expect(authentication).to have_received(:with)
          .with facebook_authentication
      end
    end

    context 'failure' do
      context 'facebook authentication' do
        before do
          allow(FacebookAuthentication).to receive(:new).and_raise :error
          post :index, signed_request: 'exception', fb_locale: 'en_US'
        end

        it 'redirect to not_found_path' do
          expect(response).to redirect_to not_found_path
        end    
      end
    end 
  end 

  describe 'listeners' do
     
    context 'on_registration_success' do
      before do
        allow(controller).to receive(:redirect_to)
        controller.on_registration_success
      end
      
      it 'redirects to new_recommendation_path path' do
        expect(controller).to have_received(:redirect_to)
          .with new_recommendation_path
      end
    end

    context 'on_login_success' do
      before do
        allow(controller).to receive(:redirect_to)
        controller.on_login_success
      end
      
      it 'redirects to new_search_path path' do
        expect(controller).to have_received(:redirect_to)
          .with new_search_path
      end
    end

    context 'on_authentication_success' do
      let(:account)  { spy ('account') }
      let(:warden)   { spy ('warden') }
      
      before do
        allow(controller).to receive(:warden).and_return warden
        allow(warden).to receive(:set_user)
        controller.on_authentication_success account
      end
      
      it 'sets warden user' do
        expect(warden).to have_received(:set_user)
          .with account
      end
    end

    context 'on_authentication_fail' do
      let(:exception)  { spy ('exception') }
      
      before do
        allow(controller).to receive(:redirect_to)
        controller.on_authentication_fail exception
      end
      
      it 'redirects to not_found_path' do
        expect(controller).to have_received(:redirect_to)
          .with not_found_path
      end
    end
  end
end
