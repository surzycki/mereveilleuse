describe UnsubscribesController do
  let(:user)                { build_stubbed :user } 
  let(:search)              { spy('search') }
  let(:message)             { spy('message') }
  let(:unsubscribe_service) { wisper_spy('unsubscribe_service') }
  
  before do 
    allow(UnsubscribeService).to receive(:new).and_return unsubscribe_service
    stubbed_sign_in user 
  end

  describe 'GET search' do 
    describe 'success' do
      before do
        allow(Search).to receive(:find_by).and_return search

        mock_wisper_publisher(unsubscribe_service, 
          :unsubscribe_search, :unsubscribe_search_success, search)

        get :search, id: 'id_of_search', token: 'login_token'
      end

      it 'returns http success' do
        expect(response).to be_success
      end

      it 'renders the application layout' do
        expect(response).to render_template(layout: 'application')
      end

      it 'renders the search template' do
        expect(response).to render_template(:search)
      end

      it 'retrieves correct search' do
        expect(Search).to have_received(:find_by)
          .with hash_including(id: 'id_of_search') 
      end

      it 'assigns search' do
        expect(assigns[:search]).to eq search
      end
    end

    describe 'failure' do
      before do
        allow(Search).to receive(:find_by).and_return nil

        mock_wisper_publisher(unsubscribe_service, 
          :unsubscribe_search, :unsubscribe_search_fail, message)

        get :search, id: 'not_found', token: 'login_token'
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end

      it 'sets flash' do
        expect(flash[:alert]).to eq message
      end 
    end

    describe 'exception' do
      before do
        allow(Search).to receive(:find_by).and_raise :error
        allow(TrackError).to receive(:new)

        get :search, id: 'not_found', token: 'login_token'
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end

      it 'tracks the error' do
        expect(TrackError).to have_received(:new)
      end
    end
  end

  describe 'GET account' do
    describe 'success' do
      before do
        mock_wisper_publisher(unsubscribe_service, 
          :unsubscribe_account, :unsubscribe_account_success, user)

        get :account, token: 'login_token'
      end

      it 'returns http success' do
        expect(response).to be_success
      end

      it 'renders the application layout' do
        expect(response).to render_template(layout: 'application')
      end

      it 'renders the account template' do
        expect(response).to render_template(:account)
      end
    end

    describe 'failure' do
      before do
        allow(controller).to receive(:current_user).and_return nil

        mock_wisper_publisher(unsubscribe_service, 
          :unsubscribe_account, :unsubscribe_account_fail, message)

        get :account, token: 'login_token'
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end

      it 'sets flash' do
        expect(flash[:alert]).to eq message
      end
    end

    describe 'exception' do
      before do
        allow(controller).to receive(:current_user).and_raise :error
        allow(TrackError).to receive(:new)

        get :account, token: 'exception'
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end

      it 'tracks the error' do
        expect(TrackError).to have_received(:new)
      end
    end
  end
end