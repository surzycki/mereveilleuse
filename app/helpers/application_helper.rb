module ApplicationHelper
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
