class HelpForm
  include ActiveModel::Model
  
  attr_accessor :email, :help_topic, :message

  validates :email, :help_topic, :message, presence: true 

  def process   
    if self.valid?
      true
    else
      false
    end
  end
end