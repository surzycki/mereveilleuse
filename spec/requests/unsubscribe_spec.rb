describe 'unsubscribe' do
  let!(:search)  { create :search }
  let!(:user)    { search.user }

  describe 'search' do
    context 'success' do
      context 'with correct token' do
        it 'changes search status' do
          expect do
            get search.unsubscribe_search_path
          end.to change { search.reload.status }
        end
  
        it 'schedules an email' do
          expect do
            get search.unsubscribe_search_path
          end.to enqueue_a(ActionMailer::DeliveryJob)
        end
      end
  
      context 'with multiple visits ' do
        before { get search.unsubscribe_search_path }
        
        it 'does NOT change search status' do
          expect do
            get search.unsubscribe_search_path
          end.to_not change { search.reload.status }
        end
  
        it 'does NOT schedule an email' do
          expect do
            get search.unsubscribe_search_path
          end.to_not enqueue_a(ActionMailer::DeliveryJob)
        end
      end
    end

    context 'fail' do
      context 'with incorrect token' do
        it 'does NOT change search status' do
          expect do
            get unsubscribe_search_path('bad_token', search.id)
          end.to_not change { search.reload.status }
        end
  
        it 'redirects to new new_registration_path' do
          get unsubscribe_search_path('bad_token', search.id)
          expect(response).to redirect_to new_registration_path
        end
      end
    end
  end


  describe 'account' do
    context 'with correct token' do
      it 'changes user status' do
        expect do
          get user.unsubscribe_account_path
        end.to change { user.reload.status }
      end

      it 'changes user search status' do
        expect do
          get user.unsubscribe_account_path
        end.to change { user.reload.searches.first.status }
      end
    end

    context 'with incorrect token' do
      it 'does NOT change search status' do
        expect do
          get unsubscribe_account_path('bad token')
        end.to_not change { user.reload.status }
      end

      it 'redirects to new new_registration_path' do
        get unsubscribe_account_path('bad token')
        expect(response).to redirect_to new_registration_path
      end
    end
  end
end