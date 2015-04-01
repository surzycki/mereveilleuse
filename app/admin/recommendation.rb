ActiveAdmin.register Recommendation do
  config.sort_order = 'created_at_desc'

  menu label: 'Recommendations', priority: 4

  permit_params :availability, :bedside_manner, :efficacy, :wait_time, :comment, :profession_id

  filter :profession,           as: :select,      collection: Profession.order('name ASC'),  label: 'Occupation'
  filter :patient_types_id_eq,  as: :select,      collection: PatientType.order('name ASC'), label: 'Patient Type'

  filter :practitioner_lastname_cont, as: :string, label: 'Practitioner Lastname'
  filter :recommender_lastname_cont,  as: :string, label: 'Mother Lastname'
  
  filter :created_at

  controller do
    def edit
      recommendation = scoped_collection.find(params[:id])
      @page_title = "#{recommendation.recommender.fullname} for #{recommendation.practitioner.fullname}"
    end
  end

  index do
    column 'Practitioner' do |recommendation|
      link_to_practitioner recommendation.practitioner
    end

    column :profession

    column 'Patient Types' do |recommendation|
      get_patient_types recommendation
    end

    column 'Mother' do |recommendation|
      link_to_user recommendation.recommender
    end

    column 'Location' do |recommendation|
      link_to_location recommendation, :short_address
    end

    column 'Rating' do |recommendation|
      recommendation.rating
    end
  
    column 'Created at' do |recommendation|
      I18n.l(recommendation.created_at, format: :short_date)  
    end

    actions
  end

  show title: proc{ |recommendation| "#{recommendation.recommender.fullname} for #{recommendation.practitioner.fullname}" } do
    attributes_table do
      row 'Practitioner' do |recommendation|
        link_to_practitioner recommendation.practitioner
      end

      row :profession
  
      row 'Patient Types' do |recommendation|
        get_patient_types recommendation
      end
  
      row 'Mother' do |recommendation|
        link_to_user recommendation.recommender
      end
  
      row :availability
      row :bedside_manner
      row :efficacy
      row :wait_time
      row :comment
      
      row 'Created at' do |recommendation|
        I18n.l(recommendation.created_at, format: :short_date)  
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs 'Recommendation' do
      f.input :profession
      
      f.input :availability
      f.input :bedside_manner
      f.input :efficacy
      f.input :wait_time

      f.input :comment
    end

    f.actions
  end
end
