ActiveAdmin.register Practitioner do
  menu label: 'Practitioner', priority: 3

  permit_params :status, :firstname, :lastname, :email, :phone, :mobile_phone,
                occupations_attributes: [ :id, :practitioner_id, :profession_id, :experience, :_destroy ]

  filter :status,                     as: :check_boxes, collection: Practitioner.statuses
  filter :professions_id_eq,          as: :select, label: 'Occupation', collection: Profession.order('name ASC')
  filter :firstname_or_lastname_cont, as: :string, label: 'Name'
  filter :email_cont,                 as: :string, label: 'Email'
  filter :location_city_cont,         as: :string, label: 'City (geocoded practitioners)'

  member_action :indexed do
    resource.indexed!
    redirect_to admin_practitioners_path, notice: 'Indexed!'
  end

  scope :all, default: true
  
  scope :indexed do |practitioner|
    practitioner.where(status: Practitioner.statuses[:indexed])
  end
  
  scope :not_indexed do |practitioner|
    practitioner.where(status: Practitioner.statuses[:not_indexed])
  end
  
  controller do
    def edit
      practitioner = scoped_collection.find(params[:id])
      @page_title = "#{practitioner.fullname}"
    end
  end

  index do
    column 'Status' do |practitioner|
      status_tag(practitioner.status, practitioner_status(practitioner))
    end
    
    column 'Name' do |practitioner|
      practitioner.fullname
    end
    
    
    column 'Occupation' do |practitioner|
      get_occupation practitioner
    end

    column :email
    
    column 'phone' do |practitioner|
      practitioner.contact_phone
    end

    column 'Location' do |practitioner|  
      link_to_location practitioner.location
    end

    column 'Geocoded?' do |practitioner|
      if practitioner.geocoded?
        status_tag('yes', :ok)
      else
        status_tag('no', :error)
      end
    end

    column 'Created' do |practitioner|
      I18n.l(practitioner.created_at, format: :short_date)  
    end

    column '' do |practitioner|
      link_to('Index', indexed_admin_practitioner_path(practitioner))
    end

    actions 
  end

  show title: proc{ |practitioner| "#{practitioner.fullname}" } do
    attributes_table do
      row 'Status' do |practitioner|
        status_tag(practitioner.status, practitioner_status(practitioner))
      end

      row 'Geocoded?' do |practitioner|
        if practitioner.geocoded?
          status_tag('yes', :ok)
        else
          status_tag('no', :error)
        end
      end

      row 'Name' do |practitioner|
        practitioner.fullname
      end
      
      row 'Occupation' do |practitioner|
        get_occupation practitioner
      end
      
      row :email
      row :phone
      row :mobile_phone
  
      row 'Location' do |practitioner|  
        link_to_location practitioner.location
      end

      row 'Insurance' do |practitioner|  
        get_insurances practitioner
      end
  
      row 'Created' do |practitioner|
        I18n.l(practitioner.created_at, format: :short_date)  
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs 'Practitioner' do
      f.input :status, as: :select, collection: Practitioner.statuses.keys
      f.input :firstname, required:  true, input_html: { value:  f.object.firstname }
      f.input :lastname,  required:  true, input_html: { value:  f.object.lastname }

      f.input :email
      f.input :phone
      f.input :mobile_phone

      f.has_many :occupations do |occupation|
        occupation.input :profession, as: :select, collection: Profession.order('name ASC')
        occupation.input :experience
        occupation.input :_destroy, as: :boolean, label: 'Remove'
      end
    end

    f.actions
  end
end
