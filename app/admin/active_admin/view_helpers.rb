module ActiveAdmin::ViewHelpers
  def user_status(user)
    status = :ok      if user.registered? 
    status = :pending if user.unregistered?
  
    status
  end

  def link_to_location(location)
    if location.present?
      link_to(location.short_address, edit_admin_location_path(location))
    else
      'Not Available'
    end
  end
end