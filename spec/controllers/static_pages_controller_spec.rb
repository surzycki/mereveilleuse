describe StaticPagesController do
  describe 'GET conditions' do
    before { get :conditions }

    it 'returns http success' do
      expect(response).to be_success
    end

    it 'renders the static_pages layout' do
      expect(response).to render_template(layout: 'static_pages')
    end

    it 'renders the conditions template' do
      expect(response).to render_template(:conditions)
    end
  end

  describe 'GET privacy' do
    before { get :privacy }

    it 'returns http success' do
      expect(response).to be_success
    end

    it 'renders the static_pages layout' do
      expect(response).to render_template(layout: 'static_pages')
    end

    it 'renders the privacy template' do
      expect(response).to render_template(:privacy)
    end
  end

  describe 'GET legal' do
    before { get :legal }

    it 'returns http success' do
      expect(response).to be_success
    end

    it 'renders the static_pages layout' do
      expect(response).to render_template(layout: 'static_pages')
    end

    it 'renders the legal template' do
      expect(response).to render_template(:legal)
    end
  end
end