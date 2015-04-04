describe ErrorsController do
  describe 'GET not_found' do
    before { get :not_found }
    
    it 'renders the application layout' do
      expect(response).to render_template(layout: 'application')
    end
    
    it 'returns status 404' do
      expect(response).to be_not_found
    end

    it 'renders the not_found template' do
      expect(response).to render_template(:not_found)
    end
  end

  describe 'GET unprocessable_entity' do
    before { get :unprocessable_entity }

    it 'renders the application layout' do
      expect(response).to render_template(layout: 'application')
    end

    it 'return status 422' do
      expect(response.status).to be_unprocessable_entity
    end

    it 'renders the unprocessable_entity template' do
      expect(response).to render_template(:unprocessable_entity)
    end
  end

  describe 'GET internal_server_error' do
    before { get :internal_server_error }
  
    it 'renders the application layout' do
      expect(response).to render_template(layout: 'application')
    end

    it 'returns status 500' do
      expect(response.status).to be_internal_server_error
    end

    it 'renders the internal_server_error template' do
      expect(response).to render_template(:internal_server_error)
    end
  end
end
