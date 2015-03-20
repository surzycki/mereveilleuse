describe SearchesController do
  describe 'GET new' do
    before do
      get :new
    end

    describe 'success' do
      it 'returns http success' do
        expect(response).to be_success
      end
    
      it 'renders the application layout' do
        expect(response).to render_template(layout: 'application')
      end
    
      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    describe 'exception' do
    end
  end

  describe 'POST create' do
  end
end
