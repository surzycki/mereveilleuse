describe RecommendationsController do
  let(:form) { spy('form') }

  before do
    allow(RecommendationForm).to receive(:new).and_return(form)
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

  describe 'PUT update' do
    context 'success' do
      context 'form step one' do
        before do
          allow(form).to receive(:next_step).and_return(true)
          
          put :update, recommendation_form: attr
        end

        it 'returns http redirect' do
          expect(response).to be_redirect
        end

        it 'redirects to edit recommendation path' do
          expect(response).to redirect_to edit_recommendation_path
        end

        it 'initializes a form' do
          expect(RecommendationForm).to have_received(:new)
        end

        it 'assigns form' do
          expect(assigns[:form]).to eq form
        end

        it 'assigns parameters to form' do
          expect(form).to have_received(:attributes=)
        end

        it 'calls next step on form' do
          expect(form).to have_received(:next_step)
        end
      end

      context 'form completed' do
        
      end
    end

    context 'fail' do
      
    end
  end
end