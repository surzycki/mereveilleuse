describe RecommendationMailer do
  let(:user)            { build_stubbed :user }
  let(:search)          { build_stubbed :search, user: user }
  let(:recommendation)  { build_stubbed :recommendation, recommender: user }

  describe 'results' do
    subject {  RecommendationMailer.results(search, [recommendation]) }

    it_behaves_like 'a multipart email'

    it 'delivers from' do
      expect(subject).to be_delivered_from(
        '"Mèreveilleuse" <team@mereveilleuse.com>'
      )
    end

    it 'delivers to' do
      expect(subject).to be_delivered_to(
        user.email
      )
    end

    it 'has a subject' do
      expect(subject).to have_subject( 
        "❤ #{I18n.t('email.recommendation.subject', profession: search.profession_name.pluralize, address: search.address )}"
      )
    end

    it 'has a recommend professionsal link' do
      expect(subject).to have_body_text( 
        new_recommendation_url
      )
    end

    it 'has a unsubscribe from search link' do
      expect(subject).to have_body_text( 
        search.unsubscribe_search_url
      )
    end

    it 'has a unsubscribe from account link' do
      expect(subject).to have_body_text( 
        user.unsubscribe_account_url
      )
    end
  end

  describe 'reciprocate' do
    subject {  RecommendationMailer.reciprocate(user) }

    let(:user)  { build_stubbed :user }

    it_behaves_like 'a multipart email'

    it 'delivers from' do
      expect(subject).to be_delivered_from(
        '"Mèreveilleuse" <team@mereveilleuse.com>'
      )
    end

    it 'delivers to' do
      expect(subject).to be_delivered_to(
        user.email
      )
    end

    it 'has a subject' do
      expect(subject).to have_subject( 
        "❤ Vous avez trouvé votre spécialiste"
      )
    end

    it 'has a recommend professionsal link' do
      expect(subject).to have_body_text( 
        new_recommendation_url
      )
    end

    it 'has a unsubscribe from account link' do
      expect(subject).to have_body_text( 
        user.unsubscribe_account_url
      )
    end
  end
end
