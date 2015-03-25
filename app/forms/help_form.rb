class HelpForm
  include ActiveModel::Model
  
  attr_accessor :email, :message, :help_topic

  def process   
    true
  end

  def errors
    'not active, job canceled'
  end
end