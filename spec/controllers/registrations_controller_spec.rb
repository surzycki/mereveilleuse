describe RegistrationsController do
  describe 'GET new' do
    describe 'success' do
      before { get :new }
  
      it 'returns http success' do
        expect(response).to be_success
      end
  
      it 'renders the application_only_footer layout' do
        expect(response).to render_template(layout: 'application_only_footer')
      end
  
      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    describe 'success phone' do
      before do
        get_as_phone :new
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
    end

    describe 'requestion authentication' do
      pending
    end
  end
end