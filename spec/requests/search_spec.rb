# spec is dependent upon geocoder stub
describe 'search' do
  let(:user)          { create :user }
  let(:patient_type)  { create :patient_type } 
  let(:profession)    { create :profession }

  describe 'create (authenticated)' do
    before { integration_sign_in user  }
    
    context 'success' do
      context 'new search' do
        let(:form_data) {{
          address:            '6 rue gobert paris france',
          profession_id:      profession.id,
          patient_type_id:    patient_type.id,
          user_id:            user.id,
        }}
  
        it 'creates search record' do
          expect do
            post search_path, search_form: form_data
          end.to change(Search, :count).by(1)
        end
  
        it 'creates location record' do
          expect do
            post search_path, search_form: form_data
          end.to change(Location, :count).by(1)
        end
  
        it 'schedules an email' do
          expect do
            post search_path, search_form: form_data 
          end.to enqueue_a(RecurringRecommendationEmailJob)
        end
      end
  
      context 'with existing search' do
        let!(:existing_search)   { create :search }
        let(:user)               { existing_search.user }
  
        let(:form_data) {{
          address:            '6 rue gobert paris france',
          profession_id:      existing_search.professions.map(&:id).join(','),
          patient_type_id:    existing_search.patient_types.map(&:id).join(','),
          information:        existing_search.information
        }}
  
        context 'when duplicate search' do
          it 'does NOT create a search record' do
            expect do
              post search_path, search_form: form_data
            end.to_not change(Search, :count)
          end
    
          it 'does NOT create a location record' do
            expect do
              post search_path, search_form: form_data
            end.to_not change(Location, :count)
          end
    
          it 'schedules an email' do
            expect do
              post search_path, search_form: form_data 
            end.to enqueue_a(RecurringRecommendationEmailJob)
          end
        end
    
        context 'when different status' do
          let!(:existing_search) { create :search, status: Search.statuses[:canceled] }
  
          it 'creates search record' do
            expect do
              post search_path, search_form: form_data
            end.to change(Search, :count).by(1)
          end
    
          it 'creates location record' do
            expect do
              post search_path, search_form: form_data
            end.to change(Location, :count).by(1)
          end
    
          it 'schedules an email' do
            expect do
              post search_path, search_form: form_data 
            end.to enqueue_a(RecurringRecommendationEmailJob)
          end
        end
        
        context 'when different patient_type' do
          let(:patient_type)  { create :patient_type }
  
          it 'creates search record' do
            expect do
              post search_path, search_form: form_data.merge(patient_type_id: patient_type.id)
            end.to change(Search, :count).by(1)
          end
    
          it 'creates location record' do
            expect do
              post search_path, search_form: form_data.merge(patient_type_id: patient_type.id)
            end.to change(Location, :count).by(1)
          end
  
          it 'schedules an email' do
            expect do
              post search_path, search_form: form_data 
            end.to enqueue_a(RecurringRecommendationEmailJob)
          end
        end
  
        context 'when different profession' do
          let(:profession)  { create :profession }
  
          it 'creates search record' do
            expect do
              post search_path, search_form: form_data.merge(profession_id: profession.id)
            end.to change(Search, :count).by(1)
          end
    
          it 'creates location record' do
            expect do
              post search_path, search_form: form_data.merge(profession_id: profession.id)
            end.to change(Location, :count).by(1)
          end
  
          it 'schedules an email' do
            expect do
              post search_path, search_form: form_data 
            end.to enqueue_a(RecurringRecommendationEmailJob)
          end
        end
  
        context 'when different address' do
          it 'creates search record' do
            expect do
              post search_path, search_form: form_data.merge(address: 'paris')
            end.to change(Search, :count).by(1)
          end
    
          it 'creates location record' do
            expect do
              post search_path, search_form: form_data.merge(address: 'paris')
            end.to change(Location, :count).by(1)
          end
  
          it 'schedules an email' do
            expect do
              post search_path, search_form: form_data 
            end.to enqueue_a(RecurringRecommendationEmailJob)
          end
        end 
  
        context 'when different user' do
          let!(:user) { create :user }
  
          it 'creates search record'  do
            expect do
              post search_path, search_form: form_data
            end.to change(Search, :count).by(1)
          end
    
          it 'creates location record' do
            expect do
              post search_path, search_form: form_data
            end.to change(Location, :count).by(1)
          end
  
          it 'schedules an email' do
            expect do
              post search_path, search_form: form_data 
            end.to enqueue_a(RecurringRecommendationEmailJob)
          end
        end 
  
        context 'when different information' do
          it 'does NOT create a search record' do
            expect do
              post search_path, search_form: form_data.merge(information: 'howdy')
            end.to_not change(Search, :count)
          end
    
          it 'does NOT create a location record' do
            expect do
              post search_path, search_form: form_data.merge(information: 'howdy')
            end.to_not change(Location, :count)
          end
  
          it 'schedules an email' do
            expect do
              post search_path, search_form: form_data 
            end.to enqueue_a(RecurringRecommendationEmailJob)
          end
        end
      end
    end

    context 'fail' do
      context 'validation error' do 
        let(:form_data) {{
          address:            '6 rue gobert paris france',
          profession_id:      '',
          patient_type_id:    patient_type.id,
          user_id:            user.id,
        }}
  
        it 'does NOT create a search record' do
          expect do
            post search_path, search_form: form_data
          end.to_not change(Search, :count)
        end
  
        it 'does NOT create a location record' do
          expect do
            post search_path, search_form: form_data
          end.to_not change(Location, :count)
        end
  
        it 'does NOT schedule an email' do
          expect do
            post search_path, search_form: form_data 
          end.to_not enqueue_a(RecurringRecommendationEmailJob)
        end
      end

      context 'address not found error' do 
        let(:form_data) {{
          address:            'blurg bad address',
          profession_id:      profession.id,
          patient_type_id:    patient_type.id,
          user_id:            user.id,
        }}
  
        it 'does NOT create a search record' do
          expect do
            post search_path, search_form: form_data
          end.to_not change(Search, :count)
        end
  
        it 'does NOT create a location record' do
          expect do
            post search_path, search_form: form_data
          end.to_not change(Location, :count)
        end
  
        it 'does NOT schedule an email' do
          expect do
            post search_path, search_form: form_data 
          end.to_not enqueue_a(RecurringRecommendationEmailJob)
        end
      end
    end
  end

  describe 'create (un-authenticated)' do
    let(:form_data) {{
      address:            '6 rue gobert paris france',
      profession_id:      profession.id,
      patient_type_id:    patient_type.id,
      user_id:            user.id,
    }}

    it 'does NOT create a search record' do
      expect do
        post search_path, search_form: form_data
      end.to_not change(Search, :count)
    end

    it 'redirects to new registrations' do
      post search_path, search_form: form_data
      expect(response).to redirect_to new_registration_path
    end
  
  end

  describe 'destroy' do
    pending
  end
end