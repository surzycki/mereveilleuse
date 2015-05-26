describe SqueezesController do
  let(:experiment) { spy('experiment') }

  describe 'GET practitioner' do
    before do
      allow(Experiments).to receive(:new).and_return experiment
      allow(experiment).to receive(:variation).and_return '1'
    end


    context 'success' do
      before { get :index, id: 'blurg' }
    
      it 'returns http success' do
        expect(response).to be_success
      end
    
      it 'renders the application_only_footer layout' do
        expect(response).to render_template(layout: 'application_only_footer')
      end
    
      it 'assigns experiment' do
        expect(assigns[:experiment]).to eq experiment
      end

      it 'renders the variation template' do
        expect(response).to render_template(:variation_1)
      end

    end

    context 'fail' do
      context 'exception' do
        before do
          allow(Experiments).to receive(:new).and_throw :error 
          allow(TrackError).to receive(:new)
          
          get :index, id: 'blurg' 
        end

        it 'redirects to internal_server_error' do
          expect(response).to redirect_to internal_server_error_path
        end

        it 'tracks the error' do
          expect(TrackError).to have_received(:new)
        end
      end
    end
  end
end