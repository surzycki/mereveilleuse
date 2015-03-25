ActiveAdmin.register HelpTopic do
  config.filters    = false
  config.sort_order = 'name_asc'
  
  menu label: 'Help Topics', parent: 'Configuration'

  permit_params :name

  controller do
    def update
      update! do |format|
        format.html { redirect_to admin_help_topics_path }
      end
    end

    def create
      create! do |format|
        format.html { redirect_to admin_help_topics_path }
      end
    end
  end

  index do
    column :name
    column :id 
    
    actions
  end

  show do
    attributes_table do
      row :name
      row :id 
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :name 
    end

    f.actions
  end
end
