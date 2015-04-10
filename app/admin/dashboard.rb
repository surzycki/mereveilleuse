ActiveAdmin.register_page "Dashboard" do

  menu priority: 0, label: proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'New Mothers', priority: 1 do
          table_for User.where(status: User.statuses[:registered]).order('created_at desc').limit(15) do
            column 'Platform' do |user|
              status_tag(user.platform, user_platform(user))
            end

            column 'Search' do |user|
              status_tag(user_search_status(user), user_search_status(user))
            end

            column 'Mother' do |user|
              link_to_user user
            end
            
            column :email
  
            column 'Location' do |user|  
              link_to_location user.location
            end
  
            column 'Member Since' do |user|
              I18n.l(user.created_at, format: :short_date)  
            end
          end
          
          strong { link_to 'View All', admin_users_path('q[status_in][]' => '1', order: 'created_at_desc') }
        end
      end

      column do
        panel 'Abandoned Mothers', priority: 1 do
          table_for User.where.not(status: User.statuses[:registered]).order('created_at desc').limit(15) do
            column 'Platform' do |user|
              status_tag(user.platform, user_platform(user))
            end
            
            column 'Mother' do |user|
              link_to_user user
            end

            column :email
  
            column 'Location' do |user|  
              link_to_location user.location
            end
  
            column 'Created' do |user|
              I18n.l(user.created_at, format: :short_date)  
            end
          end
          
          strong { link_to 'View All', admin_users_path('q[status_in][]' => '0', order: 'created_at_desc') }
        end
      end
    end

    columns do
      column do
        panel 'New Recommendations', priority: 1 do
          table_for Recommendation.order('created_at desc').limit(15) do
            column 'Practitioner' do |recommendation|
              link_to_practitioner recommendation.practitioner
            end

            column :profession
            
            column 'Patient Types' do |recommendation|
              get_patient_types recommendation
            end

            column 'Mother' do |recommendation|
              link_to_user recommendation.recommender
            end
  
            column 'Created' do |recommendation|
              I18n.l(recommendation.created_at, format: :short_date)  
            end
          end
          
          strong { link_to 'View All', admin_recommendations_path(order: 'created_at_desc') }
        end
      end

      column do
        panel 'Recent Searches', priority: 1 do
          table_for Search.where(status: Search.statuses[:active]).order('created_at desc').limit(15) do
            column 'Status' do |search|
              status_tag(search.status, search_status(search))
            end
            
            column 'Mother' do |search|
              link_to_user search.user
            end

            column 'Profession' do |search|
              get_professions search
            end
        
            column 'Patient Type' do |search|
              get_patient_types search
            end
          
            column 'Location' do |search|  
              link_to_location search.location, :address
            end
        
            column 'Created at' do |search|
              I18n.l(search.created_at, format: :short_date)  
            end
          end
          
          strong { link_to 'View All', admin_searches_path('q[status_in][]'=> '0', order: 'created_at_desc') }
        end
      end
    end

    columns do
      column do
        panel 'Modified Practitioners (not indexed)', priority: 1 do
          table_for Practitioner.where(status: Practitioner.statuses[:not_indexed]).order('created_at desc').limit(15) do
            column 'Status' do |practitioner|
              status_tag(practitioner.status, practitioner_status(practitioner))
            end

            column 'Practitioner' do |practitioner|
              link_to_practitioner practitioner
            end

            column 'Occupation' do |practitioner|
              get_occupation practitioner
            end
            
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

      column do
        panel 'New Professions (not indexed)', priority: 1 do
          table_for Profession.where(status: Profession.statuses[:not_indexed]).order('created_at desc').limit(15) do
            column 'Status' do |profession|
              status_tag(profession.status, profession_status(profession))
            end

            column :name
            
            column 'Created' do |profession|
              I18n.l(profession.created_at, format: :short_date)  
            end
          end
          
          strong { link_to 'View All', admin_professions_path('q[status_in][]'=> '0', order: 'created_at_desc') }
        end
      end
    end
  end
end
