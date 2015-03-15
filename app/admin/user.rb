ActiveAdmin.register User do
  config.sort_order = 'lastname_asc'

  menu label: 'Mothers', priority: 2

  filter :status, as: :check_boxes, collection: User.statuses
  filter :firstname_or_lastname_cont, as: :string, label: 'Name'
  filter :email_cont, as: :string, label: 'Email'
  filter :location_city_cont, as: :string, label: 'City'

  filter :created_at

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
    column :created_at
    
    actions
  end
end
