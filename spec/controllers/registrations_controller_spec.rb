describe RegistrationsController do
  describe 'GET new' do
    describe 'success' do
      before { get :new }
  
      it 'returns http success' do
        expect(response).to be_success
      end
  
      it 'renders the registrations layout' do
        expect(response).to render_template(layout: 'registrations')
      end
  
      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end
  end
end