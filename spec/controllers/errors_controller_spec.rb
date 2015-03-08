describe ErrorsController do
  describe 'GET not_found' do
    before { get :not_found }
    
    it 'returns http success' do
      expect(response).to be_success
    end

    it 'does NOT return status 404' do
      expect(response).to_not be_not_found
    end
  end

  describe 'GET unprocessable_entity' do
    before { get :unprocessable_entity }
    
    it 'returns http success' do 
      expect(response).to be_success
    end

    it 'does NOT return status 422' do
      expect(response.status).to_not be_unprocessable_entity
    end
  end

  describe 'GET internal_server_error' do
    before { get :internal_server_error }
    
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'does NOT return status 500' do
      expect(response.status).to_not be_internal_server_error
    end
  end
end
