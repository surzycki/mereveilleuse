describe UnsubscribeMailer do
  describe 'account' do
    subject { UnsubscribeMailer.account(user) }
    
    let(:user) { build_stubbed :user }

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
        "❤ Désinscription à la newsletter de MèreVeilleuse"
      )
    end

    it 'has a unsubscribe from account link' do
      expect(subject).to have_body_text( 
        user.unsubscribe_account_url
      )
    end
  end
end