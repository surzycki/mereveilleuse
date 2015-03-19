describe PractitionersController do
  let(:practitioner)  { build_stubbed :practitioner }

  describe 'GET autocomplete' do
    context 'success' do
      before do 
        allow(Practitioner).to receive_message_chain(:search, :results).and_return([practitioner])

        xhr :get, :autocomplete, query: 'Bill', format: :json
      end 

      it 'returns http success' do
        expect(response).to be_success
      end
  
      it 'returns json' do
        expect(response).to be_json
      end

      it 'assigns results' do
        expect(assigns[:results]).to eq([practitioner])
      end

      it 'searches with query' do
        expect(Practitioner).to have_received(:search)
          .with 'Bill', anything
      end
    end

    context 'exception' do
      before do 
        allow(Practitioner).to receive_message_chain(:search, :results).and_raise :error

        xhr :get, :autocomplete, query: 'Bill', format: :json
      end

      it 'returns internal_server_error' do
        expect(response.status).to be_internal_server_error
      end
    end

    context 'via http' do
      before do
        get :autocomplete, query: 'Bill'
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