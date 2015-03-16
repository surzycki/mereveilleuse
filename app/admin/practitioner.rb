ActiveAdmin.register Practitioner do
  menu label: 'Practitioner', priority: 3

  permit_params :status, :firstname, :lastname, :email, :phone, :mobile_phone,
                occupations_attributes: [ :id, :practitioner_id, :profession_id, :experience, :_destroy ]

  filter :status,                     as: :check_boxes, collection: Practitioner.statuses
  filter :professions_id_eq,          as: :select, label: 'Occupation', collection: Profession.order('name ASC')
  filter :firstname_or_lastname_cont, as: :string, label: 'Name'
  filter :email_cont,                 as: :string, label: 'Email'
  filter :location_city_cont,         as: :string, label: 'City'

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
    
    column 'Occupation' do |practitioner|
      get_occupation practitioner
    end

    column :lastname 
    column :firstname
    column :email
    column :phone
    column :mobile_phone

    column 'Location' do |practitioner|  
      link_to_location practitioner.location
    end

    column 'Created' do |practitioner|
      I18n.l(practitioner.created_at, format: :short_date)  
    end

    actions
  end

  show title: proc{ |practitioner| "#{practitioner.fullname}" } do
    attributes_table do
      row 'Status' do |practitioner|
        status_tag(practitioner.status, practitioner_status(practitioner))
      end

      row 'Occupation' do |practitioner|
        get_occupation practitioner
      end
      
      row :lastname 
      row :firstname
      row :email
      row :phone
      row :mobile_phone
  
      row 'Location' do |practitioner|  
        link_to_location practitioner.location
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
      f.input :lastname,  required:  true, input_html: { value:  f.object.lastname }
      f.input :firstname, required:  true, input_html: { value:  f.object.firstname }
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