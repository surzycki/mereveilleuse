describe RecommendationsController do
  let(:form)            { spy('form') }
  let(:wizard)          { spy('wizard') }
  let(:params)          { spy('params') }
  let(:errors)          { spy('errors') }
  let(:practitioner)    { build_stubbed :practitioner }
  let(:recommendation)  { build_stubbed :recommendation }

  before do
    allow(Recommendation).to       receive(:find).and_return recommendation
    allow(RecommendationForm).to   receive(:new).and_return form
    allow(RecommendationWizard).to receive(:new).and_return wizard
    allow(Recommendation).to       receive(:new)
    allow(Practitioner).to         receive(:find_or_create_by).and_return practitioner
  
    allow(controller).to receive(:recommendation_params).and_return params
  end

  describe 'GET new' do
    context 'success' do
      before do 
        get :new
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
  
      it 'assigns form' do
        expect(assigns[:form]).to eq form
      end
    end

    context 'unauthenticated' do
      pending 'should handle this'
    end
  end

  describe 'POST create' do
    context 'success' do
      before do
        post :create, recommendation_form: params, practitioner_id: ''
      end

      it 'initializes form with blank recommendation' do
        expect(Recommendation).to have_received(:new)
      end

      it 'finds practitioner' do
        expect(Practitioner).to have_received(:find_or_create_by)
          .with(hash_including(id: ''))
      end

      it 'assigns form' do
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
        
        post :create, recommendation_form: params, practitioner_id: ''
      end

      it 'redirects to not_found_path' do
        expect(response).to redirect_to not_found_path
      end
    end

    context 'unauthenticated' do
      pending 'should handle this'
    end
  end

  describe 'GET edit' do
    context 'success' do
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
          .with(recommendation.id.to_s)
      end
  
      it 'initializes form' do
        expect(RecommendationForm).to have_received(:new)
      end
    end

    context 'unauthenticated' do
      pending 'should handle this'
    end
  end

  describe 'PUT update' do
    context 'success' do
      before do
        put :update, id: recommendation, recommendation_form: params
      end
      
      it 'finds form' do
        expect(Recommendation).to have_received(:find)
          .with(recommendation.id.to_s)
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

    context 'unauthenticated' do
      pending 'should handle this'
    end
  end

  describe 'listeners' do
    context 'on_next_step' do
      before do
        allow(controller).to receive(:redirect_to)
        controller.on_next_step form.recommendation
      end

      it 'redirects to edit_recommendation_path' do
        expect(controller).to have_received(:redirect_to)
          .with edit_recommendation_path(form.recommendation)
      end
    end

    context 'on_form_error' do
      before do
        allow(controller).to receive(:render)
        allow(controller.flash.now).to receive(:[]=)
   
        controller.on_form_error errors
      end

      it 'renders new template' do
        expect(controller).to have_received(:render)
          .with(:new)
      end

      it 'sets flash with errors' do
        expect(controller.flash.now).to have_received(:[]=)
          .with :alert, anything
      end

      it 'retrieves error messages' do
        expect(errors).to have_received(:full_messages)
      end
    end
  end 
end