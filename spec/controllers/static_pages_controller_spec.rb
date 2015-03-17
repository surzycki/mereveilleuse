describe StaticPagesController do
  describe '#conditions' do
    before { get :conditions }

    it 'returns http success' do
      expect(response).to be_success
    end

    it 'renders the application layout' do
      expect(response).to render_template(layout: 'static_pages')
    end

    it 'renders the conditions template' do
      expect(response).to render_template(:conditions)
    end
  end

  describe '#privacy' do
    before { get :privacy }

    it 'returns http success' do
      expect(response).to be_success
    end

    it 'renders the application layout' do
      expect(response).to render_template(layout: 'static_pages')
    end

    it 'renders the privacy template' do
      expect(response).to render_template(:privacy)
    end
  end
end