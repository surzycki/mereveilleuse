describe UnsubscribeService do
  subject { UnsubscribeService.new }

  let(:search)   { spy('search') }
  let(:searches) { [ search ] }
  let(:user)     { spy('user') }
  let(:mailer)   { spy('mailer') }
  
  describe '#initialize' do
    it 'initializes' do
      expect { UnsubscribeService.new }.to_not raise_error
    end
  end

  describe '#unsubscribe_search' do
    before do 
      allow(RecommendationMailer).to receive(:reciprocate).and_return mailer
    end

    context 'success' do
      context 'with active search' do
        before do
          allow(search).to receive(:active?).and_return true
          
          subject.unsubscribe_search search
        end
        
        it 'broadcasts success' do
          expect { 
            subject.unsubscribe_search search 
          }.to broadcast(:unsubscribe_search_success, search)
        end
  
        it 'cancels search' do
          expect(search).to have_received(:canceled!)
        end
  
        it 'sends email in 48hrs' do
          expect(mailer).to have_received(:deliver_later).
            with hash_including wait: 48.hour
        end
  
        it 'sends email' do
          expect(RecommendationMailer).to have_received(:reciprocate).
            with search.user
        end
      end

      context 'with INACTIVE search' do
        before do
          allow(search).to receive(:active?).and_return false
          
          subject.unsubscribe_search search
        end
        
        it 'broadcasts success' do
          expect { 
            subject.unsubscribe_search search 
          }.to broadcast(:unsubscribe_search_success, search)
        end
  
        it 'cancels search' do
          expect(search).to have_received(:canceled!)
        end
  
        it 'does NOT send email in 48hrs' do
          expect(mailer).to_not have_received(:deliver_later)
        end
  
        it 'does NOT send email' do
          expect(RecommendationMailer).to_not have_received(:reciprocate)
        end
      end
    end

    context 'fail' do
      context 'with exception' do
        before do
          allow(search).to receive(:active?).and_throw :error
          
          subject.unsubscribe_search search
        end
        
        it 'broadcasts fail' do
          expect { 
            subject.unsubscribe_search search
          }.to broadcast(:unsubscribe_search_fail, I18n.t('unsubscribe.search.not_found'))
        end
  
        it 'does NOT send email' do
          expect(RecommendationMailer).to_not have_received(:reciprocate)
        end
      end
    end
  end

  describe '#unsubscribe_account' do
    before do
      allow(UnsubscribeMailer).to receive(:account).and_return mailer
    end

    context 'success' do
      context 'with active search' do
        before do
          allow(user).to receive(:searches).and_return searches
          
          subject.unsubscribe_account user
        end
        
        it 'broadcasts success' do
          expect { 
            subject.unsubscribe_account user 
          }.to broadcast(:unsubscribe_account_success, user)
        end
  
        it 'unsubscribes user' do
          expect(user).to have_received(:unsubscribed!)
        end
  
        it 'cancels searches' do
          expect(search).to have_received(:canceled!).once
        end

        it 'sends email' do
          expect(UnsubscribeMailer).to have_received(:account).
            with user
        end
      end
    end

    context 'fail' do
      context 'with exception' do
        before do
          allow(user).to receive(:searches).and_throw :error
          
          subject.unsubscribe_account user
        end
        
        it 'broadcasts fail' do
          expect { 
            subject.unsubscribe_account user
          }.to broadcast(:unsubscribe_account_fail, I18n.t('errors.general'))
        end
      end
    end
  end
end