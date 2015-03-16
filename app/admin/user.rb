ActiveAdmin.register User do
  config.sort_order = 'lastname_asc'

  menu label: 'Mothers', priority: 2

  permit_params :status, :firstname, :lastname, :email

  filter :status,                     as: :check_boxes, collection: User.statuses
  filter :firstname_or_lastname_cont, as: :string, label: 'Name'
  filter :email_cont,                 as: :string, label: 'Email'
  filter :location_city_cont,         as: :string, label: 'City'

  filter :created_at

  controller do
    def edit
      user = scoped_collection.find(params[:id])
      @page_title = "#{user.fullname} (#{user.email})"
    end
  end

  index do
    column 'Status' do |user|
      status_tag(user.status, user_status(user))
    end
    
    column :lastname 
    column :firstname
    column :email
    
    column 'Location' do |user|  
      link_to_location user.location
    end

    column :has_invited
    
    column 'Member Since' do |user|
      I18n.l(user.created_at, format: :short_date)  
    end

    actions
  end

  show title: proc{ |user| "#{user.fullname} (#{user.email})" } do
    attributes_table do
      row 'Status' do |user|
        status_tag(user.status, user_status(user))
      end
      
      row :lastname
      row :firstname
      row :email
      
      row 'Location' do |user|  
        link_to_location user.location
      end
  
      row :has_invited
      
      row 'Member Since' do |user|
        I18n.l(user.created_at, format: :short_date)  
      end
    end
  end


  form do |f|
    f.semantic_errors

    f.inputs 'Mother' do
      f.input :status, as: :select, collection: User.statuses.keys
      f.input :lastname,  required:  true, input_html: { value:  f.object.lastname }
      f.input :firstname, required:  true, input_html: { value:  f.object.firstname }
      f.input :email,     required:  true
    end

    f.actions
  end
end
