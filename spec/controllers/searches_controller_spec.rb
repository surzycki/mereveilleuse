describe SearchesController do
  let(:user)            { build_stubbed :user }
  let(:form)            { spy('form') }
  let(:search_service)  { spy('search_service') }
  let(:search)          { spy('search') }
  let(:provider)        { spy('provider') }
  let(:errors)          { spy('errors') }

  before do
    allow(SearchForm).to receive(:new).and_return form
    stubbed_sign_in user
  end

  describe 'GET new' do  
    describe 'success' do
      before { get :new }
      
      it 'returns http success' do
        expect(response).to be_success
      end
    
      it 'renders the application layout' do
        expect(response).to render_template(layout: 'application')
      end
    
      it 'assigns form' do
        expect(assigns[:form]).to eq form
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    describe 'exception' do
      before do
        allow(SearchForm).to receive(:new).and_throw :error        
        allow(TrackError).to receive(:new)

        get :new
      end

      it 'redirects to internal_server_error' do
        expect(response).to redirect_to internal_server_error_path
      end

      it 'tracks the error' do
        expect(TrackError).to have_received(:new)
      end
    end
  end

  describe 'POST create' do
    let(:params) {{ 
      address:          'paris',
      profession_id:    '1', 
      patient_type_id:  '1', 
      information:      'hello'
    }}

    context 'success' do
      before do
        allow(DelayedEmailSearchProvider).to receive(:new).and_return provider
        allow(SearchService).to receive(:new).and_return search_service

        post :create, search_form: params
      end

      it 'creates form' do
        expect(SearchForm).to have_received(:new)
          .with params.merge(user_id: user.id)
      end

      it 'assigns form' do
        expect(assigns[:form]).to eq form
      end

      it 'creates search service' do
        expect(SearchService).to have_received(:new)
          .with form 
      end
  
      it 'assigns search service' do
        expect(assigns[:search_service]).to eq search_service
      end

      it 'creates delayed email provider' do
        expect(DelayedEmailSearchProvider).to have_received(:new)
      end

      it 'executes search service' do
        expect(search_service).to have_received(:execute)
          .with provider
      end
    end

    context 'on success event' do
      before do
        stub_wisper_publisher('SearchService', :execute, :success, search)
      
        post :create, search_form: params
      end

      it 'returns http redirect' do
        expect(response).to be_redirect
      end

      it 'redirects to search_path' do
        expect(response).to redirect_to search_path
      end
    end

    context 'on fail event' do
      before do
        stub_wisper_publisher('SearchService', :execute, :fail, errors)
    
        post :create, search_form: params
      end

      it 'returns http success' do
        expect(response).to be_success
      end
    
      it 'renders the application layout' do
        expect(response).to render_template(layout: 'application')
      end
    
      it 'renders the new template' do
        expect(response).to render_template(:new)
      end

      it 'sets flash' do
        expect(flash[:alert]).to eq errors.full_messages
      end 
    end

    context 'exception' do
      before do
        allow(SearchService).to receive(:new).and_throw :error
        allow(TrackError).to receive(:new)

        post :create, search_form: params
      end

      it 'returns http redirect' do
        expect(response).to be_redirect
      end

      it 'redirects to internal_server_error_path' do
        expect(response).to redirect_to internal_server_error_path
      end

      it 'tracks error' do
        expect(TrackError).to have_received(:new)
      end
    end
  end
end
