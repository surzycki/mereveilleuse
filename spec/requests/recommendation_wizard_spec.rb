# wip
# spec is dependent upon geocoder stub
#describe 'recommendation wizard' do
#  let!(:user)          { create :user }
#  let!(:patient_type)  { create :patient_type } 
#  let!(:practitioner)  { create :practitioner }
#  
#  before do 
#    integration_sign_in user 
#  end
#
#  describe 'create' do
#    context 'new practitioner' do
#      let(:form_data) {{
#        practitioner_name:  'New Practitioner',
#        patient_type_id:    patient_type.id,
#        profession_id:      practitioner.primary_occupation.profession_id,
#        address:            '6 rue gobert paris france',
#        user_id:            user.id
#      }}
#
#      context 'success' do
#        it 'creates a practitioner' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to change(Practitioner, :count).by(1)
#        end
#
#        it 'creates a occupation' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to change(Occupation, :count).by(1)
#        end
#
#        it 'creates a recommendations' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to change(Recommendation, :count).by(1)
#        end
#
#        it 'creates a location' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to change(Location, :count).by(1)
#        end
#
#        it 'is not_indexed' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to_not change { Practitioner.first.status }
#        end
#      end
#
#      context 'validation error' do
#        it 'does NOT create a practitioner' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
#          end.to_not change(Practitioner, :count)
#        end
#
#        it 'does NOT create a recommendations' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
#          end.to_not change(Recommendation, :count)
#        end
#
#        it 'does NOT create a occupation' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
#          end.to_not change(Occupation, :count)
#        end
#
#        it 'does NOT create a location' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(practitioner_name: '')
#          end.to_not change(Location, :count)
#        end
#      end
#    
#    end
#
#    context 'existing practitioner (not modified)' do
#      let(:form_data) {{
#        practitioner_name:  practitioner.fullname,
#        patient_type_id:    patient_type.id,
#        profession_id:      practitioner.primary_occupation.profession_id,
#        address:            practitioner.address,
#        user_id:            user.id
#      }}
#
#      context 'success' do
#        it 'does NOT create a practitioner' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to_not change(Practitioner, :count)
#        end
#
#        it 'does NOT creates a occupation' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to_not change(Occupation, :count)
#        end
#
#        it 'creates a recommendations' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to change(Recommendation, :count).by(1)
#        end
#
#        it 'does NOT create a location' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to_not change(Location, :count)
#        end
#
#        it 'does NOT set not_indexed status' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to_not change { practitioner.reload.status }
#        end
#      end
#
#      context 'validation error' do
#        it 'does NOT create a practitioner' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
#          end.to_not change(Practitioner, :count)
#        end
#
#        it 'does NOT create a recommendations' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
#          end.to_not change(Recommendation, :count)
#        end
#
#        it 'does NOT create a occupation' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
#          end.to_not change(Occupation, :count)
#        end
#
#        it 'does NOT create a location' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
#          end.to_not change(Location, :count)
#        end
#
#        it 'does NOT set not_indexed status' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
#          end.to_not change(practitioner, :status)
#        end
#      end
#    end
#
#    # this spec uses stubs for geocoder
#    context 'existing practitioner (modified)' do
#      let(:form_data) {{
#        practitioner_name:  practitioner.fullname,
#        patient_type_id:    patient_type.id,
#        profession_id:      '9090',
#        address:            '75011',
#        user_id:            user.id
#      }}
#
#      context 'success' do
#        it 'does NOT create a practitioner' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to_not change(Practitioner, :count)
#        end
#
#        it 'creates an occupation' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to change(Occupation, :count).by(1)
#        end
#
#        it 'creates a recommendations' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to change(Recommendation, :count).by(1)
#        end
#
#        it 'sets not_indexed status' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to change { practitioner.reload.status }.to('not_indexed')
#        end
#
#        it 'changes address' do
#          expect do
#            post recommendations_path, recommendation_form: form_data
#          end.to change { practitioner.reload.address }
#        end
#      end
#
#      context 'validation error' do
#        it 'does NOT create a practitioner' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
#          end.to_not change(Practitioner, :count)
#        end
#
#        it 'does NOT create a recommendations' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
#          end.to_not change(Recommendation, :count)
#        end
#
#        it 'does NOT create a occupation' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
#          end.to_not change(Occupation, :count)
#        end
#
#        it 'does NOT set not_indexed status' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
#          end.to_not change { practitioner.reload.status }
#        end
#
#        it 'oes NOT change address' do
#          expect do
#            post recommendations_path, recommendation_form: form_data.merge(patient_type_id: '')
#          end.to_not change { practitioner.reload.address }
#        end
#      end
#    end
#  end
#
#  describe 'update' do
#    let(:recommendation) { create :recommendation, :step_two }
#
#    let(:form_data) {{
#      wait_time:        '1',
#      availability:     '1',
#      bedside_manner:   '1',
#      efficacy:         '1',
#      comment:          'comment'
#    }}
#  
#    context 'success' do
#      it 'updates wait_time' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data
#        end.to change{ recommendation.reload.wait_time }.to(1)
#      end
#
#      it 'updates availability' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data
#        end.to change{ recommendation.reload.availability }.to(1)
#      end
#
#      it 'updates bedside_manner' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data
#        end.to change{ recommendation.reload.bedside_manner }.to(1)
#      end
#
#      it 'updates efficacy' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data
#        end.to change{ recommendation.reload.efficacy }.to(1)
#      end
#
#      it 'updates comment' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data
#        end.to change{ recommendation.reload.comment }.to('comment')
#      end
#
#      it 'updates state' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data
#        end.to change{ recommendation.reload.state }.from('step_two').to('completed')
#      end
#    end
#
#    context 'validation error' do
#      it 'does NOT update wait_time' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data.merge(efficacy: '')
#        end.to_not change{ recommendation.reload.wait_time }
#      end
#
#      it 'does NOT update availability' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data.merge(efficacy: '')
#        end.to_not change{ recommendation.reload.availability }
#      end
#
#      it 'does NOT update bedside_manner' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data.merge(efficacy: '')
#        end.to_not change{ recommendation.reload.bedside_manner }
#      end
#
#      it 'does NOT update efficacy' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data.merge(efficacy: '')
#        end.to_not change{ recommendation.reload.efficacy }
#      end
#
#      it 'does NOT update comment' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data.merge(efficacy: '')
#        end.to_not change{ recommendation.reload.comment }
#      end
#
#      it 'does NOT update state' do
#        expect do
#          put recommendation_path(recommendation), recommendation_form: form_data.merge(efficacy: '')
#        end.to_not change{ recommendation.reload.state }
#      end
#    end
#  end
#end#