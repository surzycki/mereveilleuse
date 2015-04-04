ActiveAdmin.register User do
  config.sort_order = 'created_at_desc'

  menu label: 'Mothers', priority: 2

  permit_params :status, :firstname, :lastname, :email

  filter :status,                     as: :check_boxes, collection: User.statuses
  filter :firstname_or_lastname_cont, as: :string, label: 'Name'
  filter :email_cont,                 as: :string, label: 'Email'
  filter :location_city_cont,         as: :string, label: 'City'

  filter :created_at

  scope :all, default: true
  
  scope :registered do |user|
    user.where(status: User.statuses[:registered])
  end
  
  scope :unregistered do |user|
    user.where(status: User.statuses[:unregistered])
  end

  controller do
    def edit
      user = scoped_collection.find(params[:id])
      @page_title = "#{user.fullname} (#{user.email})"
    end
  end

  index title: 'Mothers' do
    column :verified

    column 'Status' do |user|
      status_tag(user.status, user_status(user))
    end

    column 'Name' do |user|
      link_to_facebook_profile user
    end
    
    column :email
    
    column 'Location' do |user|  
      link_to_location user.location
    end

    column 'Friend Count' do |user|  
      status_tag(user.friend_count, friend_count_status(user))
    end
    
    column :has_invited
    
    column 'Member Since' do |user|
      I18n.l(user.created_at, format: :short_date)  
    end

    actions
  end

  show title: proc{ |user| "#{user.fullname} (#{user.email})" } do
    attributes_table do
      row :verified

      row 'Status' do |user|
        status_tag(user.status, user_status(user))
      end
      
      row 'Name' do |user|
        user.fullname
      end
      
      row :email
      
      row 'Location' do |user|  
        link_to_location user.location
      end
  
      row :friend_count
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
      f.input :firstname, required:  true, input_html: { value:  f.object.firstname }
      f.input :lastname,  required:  true, input_html: { value:  f.object.lastname }
      f.input :email,     required:  true
    end

    f.actions
  end
end
