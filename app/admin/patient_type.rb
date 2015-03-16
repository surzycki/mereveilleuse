ActiveAdmin.register PatientType do
  config.filters    = false
  config.sort_order = 'name_asc'

  actions :all, except: [:destroy]
  menu label: 'Patient Types', parent: 'Configuration'

  permit_params :name

  controller do
    def update
      update! do |format|
        format.html { redirect_to admin_patient_types_path }
      end
    end

    def create
      create! do |format|
        format.html { redirect_to admin_patient_types_path }
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
