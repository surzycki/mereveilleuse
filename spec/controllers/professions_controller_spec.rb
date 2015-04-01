describe ProfessionsController do
  let(:profession)  { build_stubbed :profession }

  describe 'GET autocomplete' do
    context 'success' do
      before do 
        allow(Profession).to receive_message_chain(:search, :results).and_return([profession])

        xhr :get, :autocomplete, query: 'Doctor', format: :json
      end 

      it 'returns http success' do
        expect(response).to be_success
      end
  
      it 'returns json' do
        expect(response).to be_json
      end

      it 'assigns results' do
        expect(assigns[:results]).to eq([profession])
      end

      it 'searches with query' do
        expect(Profession).to have_received(:search)
          .with 'Doctor', anything
      end
    end

    context 'exception' do
      before do 
        allow(Profession).to receive_message_chain(:search, :results).and_raise :error

        xhr :get, :autocomplete, query: 'Doctor', format: :json
      end

      it 'returns internal_server_error' do
        expect(response.status).to be_internal_server_error
      end
    end

    context 'via http' do
      before do
        get :autocomplete, query: 'Doctor'
      end

      it 'returns http redirect' do
        expect(response).to be_redirect
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end
  end
end