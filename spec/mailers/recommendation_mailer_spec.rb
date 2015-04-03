describe RecommendationMailer do
  describe 'results' do
    let(:search)          { create :search }
    let(:recommendation)  { build_stubbed :recommendation }
    let(:user)            { search.user }

    let(:mail) { RecommendationMailer.results(search, [recommendation]) }
  
    it_behaves_like 'a multipart email'

    it 'delivers from' do
      expect(mail).to be_delivered_from(
        '"Mèreveilleuse" <team@mereveilleuse.com>'
      )
    end

    it 'delivers to' do
      expect(mail).to be_delivered_to(
        user.email
      )
    end

    it 'has a subject' do
      expect(mail).to have_subject( 
        "❤ #{I18n.t('email.recommendation.subject', profession: search.profession_name.pluralize, address: search.address )}"
      )
    end

    it 'has a recommend professionsal link' do
      expect(mail).to have_body_text( 
        canvas_recommendation_path
      )
    end

    it 'has a unsubscribe from search link' do
      expect(mail).to have_body_text( 
        canvas_unsubscribe_search_path search
      )
    end

    it 'has a unsubscribe from account link' do
      expect(mail).to have_body_text( 
        canvas_unsubscribe_account_path user
      )
    end
  end
end
