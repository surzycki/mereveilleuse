describe UnsubscribesController do
  let(:user)  { build_stubbed :user } 

  before { stubbed_sign_in user }

  describe 'GET search' do
    let(:search) { spy('search') }
      
    describe 'success' do
      before do
        allow(Search).to receive(:find_by).and_return search

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

      it 'cancels search' do
        expect(search).to have_received(:canceled!)
      end 
    end

    describe 'failure' do
      before do
        allow(Search).to receive(:find_by).and_return nil

        get :search, id: 'not_found', token: 'login_token'
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end

      it 'does NOT cancel search' do
        expect(search).to_not have_received(:canceled!)
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
    before do
      allow(user).to receive(:unsubscribe)
    end

    describe 'success' do
      before do
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

      it 'unsubscribes user' do
        expect(user).to have_received(:unsubscribe)
      end 
    end

    describe 'failure' do
      before do
        allow(controller).to receive(:current_user).and_return nil

        get :account, token: 'login_token'
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end

      it 'does NOT unsubscribe user' do
        expect(user).to_not have_received(:unsubscribe)
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