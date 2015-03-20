ActiveAdmin.register_page "Dashboard" do

  menu priority: 0, label: proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'New Mothers', priority: 1 do
          table_for User.where(status: User.statuses[:registered]).order('created_at desc').limit(15) do
            column :lastname 
            column :firstname
            column :email
  
            column 'Location' do |practitioner|  
              link_to_location practitioner.location
            end
  
            column 'Member Since' do |practitioner|
              I18n.l(practitioner.created_at, format: :short_date)  
            end
          end
          
          strong { link_to 'View All', admin_users_path('q[status_in][]' => '1', order: 'created_at_desc') }
        end
      end

      column do
        panel 'Abandoned Mothers', priority: 1 do
          table_for User.where.not(status: User.statuses[:registered]).order('created_at desc').limit(15) do
            column :lastname 
            column :firstname
            column :email
  
            column 'Location' do |practitioner|  
              link_to_location practitioner.location
            end
  
            column 'Created' do |practitioner|
              I18n.l(practitioner.created_at, format: :short_date)  
            end
          end
          
          strong { link_to 'View All', admin_users_path('q[status_in][]' => '0', order: 'created_at_desc') }
        end
      end
    end

    columns do
      column do
        panel 'New Recommendations', priority: 1 do
          table_for Recommendation.where(state: 'completed').order('created_at desc').limit(15) do
            column 'Practitioner' do |recommendation|
              link_to_practitioner recommendation.practitioner
            end

            column :profession
            
            column 'Patient Types' do |recommendation|
              get_patient_types recommendation
            end

            column 'Mother' do |recommendation|
              link_to_user recommendation.user
            end
  
            column 'Created' do |practitioner|
              I18n.l(practitioner.created_at, format: :short_date)  
            end
          end
          
          strong { link_to 'View All', admin_recommendations_path('q[state_in][]'=> 'completed', order: 'created_at_desc') }
        end
      end

      column do
        panel 'Abandoned Recommendations', priority: 1 do
          table_for Recommendation.where.not(state: 'completed').order('created_at desc').limit(15) do
            column :profession
            
            column 'Patient Types' do |recommendation|
              get_patient_types recommendation
            end

            column 'Practitioner' do |recommendation|
              link_to_practitioner recommendation.practitioner
            end

            column 'Mother' do |recommendation|
              link_to_user recommendation.user
            end
  
            column 'Created' do |practitioner|
              I18n.l(practitioner.created_at, format: :short_date)  
            end
          end
                                      
          strong { link_to 'View All', "#{admin_recommendations_path}/?q[state_in][]=step_one&q[state_in][]=step_two&order=created_at_desc" }
        end
      end
    end

    columns do
      column do
        panel 'Modified Practitioners (not indexed)', priority: 1 do
          table_for Practitioner.where(status: Practitioner.statuses[:not_indexed]).order('created_at desc').limit(15) do
            column 'Occupation' do |practitioner|
              get_occupation practitioner
            end

            column :lastname 
            column :firstname
            column :email

            column 'Location' do |practitioner|  
              link_to_location practitioner.location
            end
        
            column 'Created' do |practitioner|
              I18n.l(practitioner.created_at, format: :short_date)  
            end
          end
          
          strong { link_to 'View All', admin_practitioners_path('q[status_in][]'=> '0', order: 'created_at_desc') }
        end
      end
    end
  end
end
