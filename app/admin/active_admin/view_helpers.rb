module ActiveAdmin::ViewHelpers
  def user_status(user)
    status = :ok      if user.registered? 
    status = :error   if user.unregistered?
  
    status
  end

  def practitioner_status(practitioner)
    status = :ok      if practitioner.indexed? 
    status = :error   if practitioner.not_indexed?
  
    status
  end

  def link_to_location(location)
    if location.present?
      link_to(location.short_address, edit_admin_location_path(location))
    else
      I18n.t('not_available')
    end
  end

  def link_to_practitioner(practitioner)
    if practitioner.present?
      link_to(practitioner.fullname, admin_practitioner_path(practitioner))
    else
      I18n.t('not_available')
    end
  end

  def link_to_user(user)
    if user.present?
      link_to(user.fullname, admin_user_path(user))
    else
      I18n.t('not_available')
    end
  end

  def get_occupation(practitioner)
    occupations = practitioner.occupations.map { |x| x.name }
    occupations.join(', ')
  end

  def get_patient_types(recommendation)
    patient_types = recommendation.patient_types.map { |x| x.name }
    patient_types.join(', ')
  end

end