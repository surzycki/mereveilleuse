describe SessionsController do
  describe 'POST index' do
    context 'registration' do
      context 'successful' do
        before do
          post :index, signed_request: '1234', fb_locale: 'en_US'
        end

        it 'returns http redirect' do
          expect(response).to be_redirect
        end

        it 'redirects to the referals path' do
          expect(response).to redirect_to referral_path
        end
        
        it 'decodes signed_request' do
          
        end

        it 'creates user' do
          
        end
      end

      context 'failure' do
        before do
          post :index, signed_request: '1234', fb_locale: 'en_US'
        end

        it 'does NOT create user' do
          
        end
      end

      context 'exception' do
      end
    end

    context 'authentication' do
      context 'successful' do
        before do
          post :index, signed_request: '1234', fb_locale: 'en_US'
        end

        it 'returns http redirect' do
          expect(response).to be_redirect
        end

        it 'redirects to the searches path' do
          expect(response).to redirect_to search_path
        end
        
        it 'decodes signed_request' do
          
        end

        it 'returns correct user' do
          
        end
      end

      context 'failure' do
      end

      context 'exception' do
      end
    end
  end 
end
