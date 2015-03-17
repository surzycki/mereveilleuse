module ApplicationHelper
  def facebook_javascript_sdk(value = true)
    return unless value
    
    render 'shared/facebook_javascript_sdk'
  end
end
