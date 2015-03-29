module ApplicationHelper
  def apply_blur?
    return if (Rails.env.development? || Rails.env.test? )
    
    'blur' if (content_for(:apply_blur) == 'true')
  end

  def brand
    image_tag 'logo-small.png'
  end

  def copyright
    "&copy; #{Time.now.year} FST Tous droits réservés.".html_safe
  end

  def customer_service
    link_to I18n.t('customer_service'), help_path
  end
end
