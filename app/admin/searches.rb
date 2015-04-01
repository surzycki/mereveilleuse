ActiveAdmin.register Search do
  config.sort_order = 'created_at_desc'

  actions :all, except: [:edit, :destroy]

  menu label: 'Searches', priority: 4

  filter :status,                     as: :check_boxes, collection: Search.statuses
  filter :profession
  filter :patient_type
  filter :location_city_cont,         as: :string, label: 'City'

  filter :created_at

  member_action :cancel do
    resource.canceled!
    redirect_to admin_searches_path, notice: 'Canceled!'
  end

  scope :all, default: true
  
  scope :active do |search|
    search.where(status: Search.statuses[:active])
  end
  
  scope :canceled do |search|
    search.where(status: Search.statuses[:canceled])
  end

  index title: 'Searches' do
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

    column 'Sent Practitioners' do |search|  
      search.sent_practitioners.count
    end

    column 'Last sent' do |search|
      if search.sent_practitioners.count > 0
        I18n.l(search.updated_at, format: :short)
      else
        '--'
      end
    end

    column 'Next scheduled' do |search|
      if search.sent_practitioners.count > 0
        I18n.l(search.updated_at + ENV['EMAIL_INTERVAL'].to_i.minutes, format: :short)
      else
        '--'
      end
    end

    actions defaults: false do |search|
      link_to('Cancel', cancel_admin_search_path(search))
    end
  end
end
