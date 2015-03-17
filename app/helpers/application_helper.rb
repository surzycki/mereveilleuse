module ApplicationHelper
  def apply_blur?
    'blur' if (content_for(:apply_blur) == 'true')
  end
end
