module ApplicationHelper
  def apply_blur?
    return if (Rails.env.development? || Rails.env.test? )
    
    'blur' if (content_for(:apply_blur) == 'true')
  end

  def brand
    image_tag 'logo-small.png'
  end
end
