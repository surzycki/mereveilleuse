module ActiveAdmin::ViewHelpers
  require 'time_difference' 

  def arbre(&block)
    Arbre::Context.new(&block).to_s
  end

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

  def profession_status(profession)
    status = :ok      if profession.indexed? 
    status = :error   if profession.not_indexed?
  
    status
  end

  def search_status(search)
    status = :ok      if search.active? 
    status = :error   if search.canceled?
  
    status
  end

  def user_search_status(user)
    status = :yes    if user.searches
    status = :no     if user.searches.empty?

    status
  end

  def last_sent_search(search)
    return '--' if search.sent_practitioners.count == 0
    
    last_sent_in_seconds = TimeDifference.between(search.updated_at,DateTime.now).in_seconds

    status = :ok       if last_sent_in_seconds < ( ENV['EMAIL_INTERVAL'].to_i * 2 )
    status = :no       if last_sent_in_seconds > ( ENV['EMAIL_INTERVAL'].to_i * 2.1 )
    status = :error    if last_sent_in_seconds > ( ENV['EMAIL_INTERVAL'].to_i * 4 )

    status = :pending  if search.canceled?

    arbre do
      status_tag(I18n.l(search.updated_at, format: :short), status)
    end
  end

  def friend_count_status(user)
    return :error if user.friend_count.nil?

    status = :ok       if user.friend_count > 200
    status = :no       if user.friend_count < 200
    status = :error    if user.friend_count < 50

    status
  end

  def link_to_location(location, type = :address)
    if location.present?
      link_to(location.send(type), edit_admin_location_path(location))
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

  def link_to_facebook_profile(user)
    if user.present?
      link_to(user.fullname, "https://www.facebook.com/#{user.facebook_id}", target: '_blank')
    else
      I18n.t('not_available')
    end
  end


  def get_occupation(practitioner)
    occupations = practitioner.occupations.map { |x| x.name }
    occupations.join(', ')
  end

  def get_patient_types(resource)
    patient_types = resource.patient_types.map { |x| x.name }
    patient_types.join(', ')
  end

  def get_professions(resource)
    professions = resource.professions.map { |x| x.name }
    professions.join(', ')
  end

  def get_insurances(resource)
    insurances = resource.insurances.map { |x| x.name }
    insurances.join(', ')
  end
end