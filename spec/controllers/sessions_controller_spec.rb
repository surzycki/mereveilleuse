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

    #context 'registration' do
    #  context 'successful' do
    #    before do
    #      post :index, signed_request: '1234', fb_locale: 'en_US'
    #    end
#
    #    it 'returns http redirect' do
    #      expect(response).to be_redirect
    #    end
#
    #    it 'redirects to the referals path' do
    #      expect(response).to redirect_to referral_path
    #    end
    #    
    #    it 'decodes signed_request' do
    #      expect(SignedRequest).to have_received(:new)
    #        .with('1234')
    #    end
#
    #    it 'authenticates the user' do
    #      expect(Authentication).to have_received(:for)
    #    end
    #  end
#
    #  context 'bad signed_request' do
    #    before do
    #      allow(signed_request).to receive(:valid_signature?).and_return false
#
    #      post :index, signed_request: 'bad_request', fb_locale: 'en_US'
    #    end
#
    #    it 'returns http redirect' do
    #      expect(response).to be_redirect
    #    end
#
    #    it 'redirects to 404' do
    #      expect(response).to redirect_to not_found_path
    #    end
    #    
    #    it 'decodes signed_request' do
    #      expect(SignedRequest).to have_received(:new)
    #        .with('bad_request')
    #    end
#
    #    it 'does NOT authenticate the user' do
    #      expect(Authentication).to_not have_received(:for)
    #    end
    #  end
    #end
#
    #context 'login' do
    #  context 'successful' do
    #    before do
    #      allow(signed_request).to receive(:valid_signature?).and_return true
    #      allow(authentication).to receive(:registering?).and_return false
#
    #      post :index, signed_request: '1234', fb_locale: 'en_US'
    #    end
#
    #    it 'returns http redirect' do
    #      expect(response).to be_redirect
    #    end
#
    #    it 'redirects to the searches path' do
    #      expect(response).to redirect_to search_path
    #    end
    #    
    #    it 'decodes signed_request' do
    #      expect(SignedRequest).to have_received(:new)
    #        .with('1234')
    #    end
#
    #    it 'authenticates the user' do
    #      expect(Authentication).to have_received(:for)
    #    end
    #  end
#
    #  context 'failure' do
    #    before do
    #      allow(signed_request).to receive(:valid_signature?).and_return false
#
    #      post :index, signed_request: 'bad_request', fb_locale: 'en_US'
    #    end
#
    #    it 'returns http redirect' do
    #      expect(response).to be_redirect
    #    end
#
    #    it 'redirects to 404' do
    #      expect(response).to redirect_to not_found_path
    #    end
    #    
    #    it 'decodes signed_request' do
    #      expect(SignedRequest).to have_received(:new)
    #        .with('bad_request')
    #    end
#
    #    it 'does NOT authenticate the user' do
    #      expect(Authentication).to_not have_received(:for)
    #    end
    #  end
    #end
  end 
end
