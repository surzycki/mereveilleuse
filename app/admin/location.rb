ActiveAdmin.register Location do
  config.filters = false

  menu false

  permit_params :street, :city, :postal_code, :country

  controller do
    def edit
      location = scoped_collection.find(params[:id])
      @page_title = "#{location.address}"
    end
  end

  index do
    column :street
    column :city
    column :postal_code
    column :country

    column :unparsed_address

    actions
  end

  show title: proc{ |location| location.locatable.fullname } do
    attributes_table do
      row :street
      row :city
      row :postal_code
      row :country

      row :unparsed_address
    end
  end

  # Edit #
  form do |f|
    f.semantic_errors

    f.inputs 'Location' do
      f.input :street
      f.input :city
      f.input :postal_code
      f.input :country, as: :string     
    end

    f.actions
  end
end
