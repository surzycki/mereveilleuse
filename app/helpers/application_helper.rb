module ApplicationHelper
  def facebook_javascript_sdk(value = 'yes')
    return if value == 'no'
    
    render 'shared/facebook_javascript_sdk'
  end
end
