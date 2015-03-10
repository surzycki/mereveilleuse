describe RecommendationsController do
  let(:form)            { spy('form') }
  let(:wizard)          { spy('wizard') }
  let(:params)          { spy('params') }
  let(:errors)          { spy('errors') }
  let(:recommendation)  { build_stubbed :recommendation }
  
  before do
    allow(Recommendation).to       receive(:find).and_return recommendation
    allow(RecommendationForm).to   receive(:new).and_return form
    allow(RecommendationWizard).to receive(:new).and_return wizard
    allow(controller).to receive(:recommendation_params).and_return params
  end

  describe 'GET new' do
    before { get :new }

    it 'returns http success' do
      expect(response).to be_success
    end
  
    it 'renders the application layout' do
      expect(response).to render_template(layout: 'application')
    end
  
    it 'renders the new template' do
      expect(response).to render_template(:new)
    end

    it 'initializes form' do
      expect(assigns[:form]).to eq form
    end
  end

  describe 'POST create' do
    context 'success' do
      before do
        post :create, recommendation_form: params 
      end

      it 'initializes form' do
        expect(assigns[:form]).to eq form
      end

      it 'initializes wizard with context' do
        expect(RecommendationWizard).to have_received(:new)
          .with controller
      end

      it 'sets wizard' do
        expect(wizard).to have_received(:set)
          .with form, params
      end
    end

    context 'exception' do
      before do
        allow(wizard).to receive(:set).and_throw :error
        
        post :create, recommendation_form: params 
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end
    end
  end

  describe 'GET edit' do
    before { get :edit, id: recommendation }

    it 'returns http success' do
      expect(response).to be_success
    end
  
    it 'renders the application layout' do
      expect(response).to render_template(layout: 'application')
    end
  
    it 'renders the new template' do
      expect(response).to render_template(:new)
    end

    it 'finds form' do
      expect(Recommendation).to have_received(:find)
    end

    it 'initializes form' do
      expect(RecommendationForm).to have_received(:new)
    end
  end

  describe 'PUT update' do
    context 'success' do
      before do
        put :update, id: recommendation, recommendation_form: params
      end
      
      it 'finds form' do
        expect(Recommendation).to have_received(:find)
      end
  
      it 'initializes form' do
        expect(RecommendationForm).to have_received(:new)
      end

      it 'initializes wizard with context' do
        expect(RecommendationWizard).to have_received(:new)
          .with controller
      end

      it 'sets wizard' do
        expect(wizard).to have_received(:set)
          .with form, params
      end
    end

    context 'exception' do
      before do
        allow(wizard).to receive(:set).and_throw :error
        
        put :update, id: recommendation, recommendation_form: params
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end
    end
  end
end