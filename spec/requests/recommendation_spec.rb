# spec is dependent upon geocoder stub
describe 'recommendation' do
  let!(:user)          { create :user }
  let!(:patient_type)  { create :patient_type } 
  let!(:practitioner)  { create :practitioner }

  before { integration_sign_in user }

  describe 'create' do
    context 'new practitioner' do
      let(:form_data) {{
        practitioner_name:  'New Practitioner',
        patient_type_id:    patient_type.id,
        profession_id:      practitioner.primary_occupation.profession_id,
        address:            '6 rue gobert paris france',
        wait_time:          2,
        availability:       2,
        bedside_manner:     4,
        efficacy:           4
      }}

      context 'success' do
        it 'creates a practitioner' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to change(Practitioner, :count).by(1)
        end

        it 'creates a occupation' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to change(Occupation, :count).by(1)
        end

        it 'creates a recommendations' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to change(Recommendation, :count).by(1)
        end

        it 'creates a location' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to change(Location, :count).by(1)
        end

        it 'has practitioner not indexed' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to_not change { Practitioner.first.status }
        end

        it 'has a correct recommendation' do
          post recommendations_path, recommendation_form: form_data

          expect(Recommendation.first.rating).to be 3.0
        end
      end

      context 'validation error' do
        it 'does NOT create a practitioner' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
          end.to_not change(Practitioner, :count)
        end

        it 'does NOT create a recommendations' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
          end.to_not change(Recommendation, :count)
        end

        it 'does NOT create a occupation' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
          end.to_not change(Occupation, :count)
        end

        it 'does NOT create a location' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
          end.to_not change(Location, :count)
        end
      end
    end

    context 'existing practitioner (not modified)' do
      let(:form_data) {{
        practitioner_name:  practitioner.fullname,
        patient_type_id:    patient_type.id,
        profession_id:      practitioner.primary_occupation.profession_id,
        address:            practitioner.address,
        wait_time:          2,
        availability:       2,
        bedside_manner:     4,
        efficacy:           4
      }}
      
      context 'success' do
        it 'does NOT create a practitioner' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to_not change(Practitioner, :count)
        end

        it 'does NOT creates a occupation' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to_not change(Occupation, :count)
        end

        it 'creates a recommendations' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to change(Recommendation, :count).by(1)
        end

        it 'does NOT create a location' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to_not change(Location, :count)
        end

        it 'has a correct recommendation' do
          post recommendations_path, recommendation_form: form_data

          expect(Recommendation.first.rating).to be 3.0
        end
      end

      context 'validation error' do
        it 'does NOT create a practitioner' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
          end.to_not change(Practitioner, :count)
        end

        it 'does NOT create a recommendations' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
          end.to_not change(Recommendation, :count)
        end

        it 'does NOT create a occupation' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
          end.to_not change(Occupation, :count)
        end

        it 'does NOT create a location' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
          end.to_not change(Location, :count)
        end
      end
    end


    context 'existing practitioner (modified)' do
      let(:form_data) {{
        practitioner_name:  practitioner.fullname,
        patient_type_id:    patient_type.id,
        profession_id:      '9090',
        address:            'paris',
        wait_time:          2,
        availability:       2,
        bedside_manner:     4,
        efficacy:           4
      }}

      context 'success' do
        it 'does NOT create a practitioner' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to_not change(Practitioner, :count)
        end

        it 'creates an occupation' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to change(Occupation, :count).by(1)
        end

        it 'creates a recommendations' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to change(Recommendation, :count).by(1)
        end

        it 'sets not_indexed status' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to change { practitioner.reload.status }.to('not_indexed')
        end

        it 'changes address' do
          expect do
            post recommendations_path, recommendation_form: form_data
          end.to change { practitioner.reload.address }
        end

        it 'has a correct recommendation' do
          post recommendations_path, recommendation_form: form_data

          expect(Recommendation.first.rating).to be 3.0
        end
      end

      context 'validation error' do
        it 'does NOT create a practitioner' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
          end.to_not change(Practitioner, :count)
        end

        it 'does NOT create a recommendations' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
          end.to_not change(Recommendation, :count)
        end

        it 'does NOT create a occupation' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
          end.to_not change(Occupation, :count)
        end

        it 'does NOT set not_indexed status' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
          end.to_not change { practitioner.reload.status }
        end

        it 'oes NOT change address' do
          expect do
            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
          end.to_not change { practitioner.reload.address }
        end
      end
    end
  end
end