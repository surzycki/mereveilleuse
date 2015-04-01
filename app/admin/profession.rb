ActiveAdmin.register Profession do
  config.filters    = false
  config.sort_order = 'name_asc'

  actions :all, except: [:destroy]
  menu label: 'Professions', parent: 'Configuration'

  permit_params :name, :status

  member_action :indexed do
    resource.indexed!
    redirect_to admin_professions_path, notice: 'Indexed!'
  end

  scope :all, default: true
  
  scope :indexed do |profession|
    profession.where(status: Profession.statuses[:indexed])
  end
  
  scope :not_indexed do |profession|
    profession.where(status: Profession.statuses[:not_indexed])
  end

  controller do
    def update
      update! do |format|
        format.html { redirect_to admin_professions_path }
      end
    end

    def create
      create! do |format|
        format.html { redirect_to admin_professions_path }
      end
    end
  end

  index do
    column 'Status' do |profession|
      status_tag(profession.status, profession_status(profession))
    end

    column :name
    column '# of Practitioners' do |profession|
      profession.occupations.count
    end

    column 'Created' do |profession|
      I18n.l(profession.created_at, format: :short_date)  
    end
    
    actions
  end

  show do
    attributes_table do
      row 'Status' do |profession|
        status_tag(profession.status, profession_status(profession))
      end

      row :name
      row :id 

      row 'Created' do |profession|
        I18n.l(profession.created_at, format: :short_date)  
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :status, as: :select, collection: Profession.statuses.keys
      f.input :name 
    end

    f.actions
  end
end
