describe RecommendationsController do
  let(:user)                   { build_stubbed :user } 
  let(:form)                   { spy('form') }  
  let(:recommendation)         { spy('recommendation') }
  let(:errors)                 { spy('errors') }
  let(:recommendation_service) { wisper_spy('recommendation_service') }
  let(:geocode_listener)       { spy('geocode_listener') }

  before do
    allow(RecommendationService).to receive(:new).and_return recommendation_service
    allow(RecommendationForm).to receive(:new).and_return form
    allow(GeocodeListener).to receive(:new).and_return geocode_listener
    allow(user).to receive(:registered!)

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
        allow(RecommendationForm).to receive(:new).and_throw :error        
        allow(TrackError).to receive(:new)

        get :new
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end

      it 'tracks the error' do
        expect(TrackError).to have_received(:new)
      end
    end
  end

  describe 'POST create' do
    let(:params) {{ 
      practitioner_name:  'Bob Hoper',
      patient_type_id:    '1', 
      profession_name:    'Doctor', 
      address:            'paris',
      wait_time:          '1',
      availability:       '1', 
      bedside_manner:     '1', 
      efficacy:           '1'
    }}

    context 'success' do
      before do
        
        mock_wisper_publisher(recommendation_service, 
          :create_recommendation, :recommendation_created, recommendation)
        
        post :create, recommendation_form: params
      end

      it 'creates form' do
        expect(RecommendationForm).to have_received(:new)
          .with params.merge(user_id: user.id)
      end

      it 'assigns form' do
        expect(assigns[:form]).to eq form
      end

      it 'creates recommendation service' do
        expect(RecommendationService).to have_received(:new)
          .with form 
      end
  
      it 'assigns recommendation service' do
        expect(assigns[:recommendation_service]).to eq recommendation_service
      end

      it 'create recommendation' do
        expect(recommendation_service).to have_received(:create_recommendation)
      end

      it 'returns http redirect' do
        expect(response).to be_redirect
      end

      it 'redirects to recommendation_path' do
        expect(response).to redirect_to recommendation_path(recommendation)
      end

      it 'registers user' do
        expect(user).to have_received(:registered!)
      end

      it 'inits geocoder listener' do
        expect(GeocodeListener).to have_received :new
      end

      it 'geocode recommendation' do
        expect(geocode_listener).to have_received :recommendation
      end
    end

    context 'fail' do
      before do
        mock_wisper_publisher(recommendation_service, 
          :create_recommendation, :recommendation_create_fail, errors)
      
        post :create, recommendation_form: params
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
        allow(RecommendationService).to receive(:new).and_throw :error
        allow(TrackError).to receive(:new)

        post :create, recommendation_form: params
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