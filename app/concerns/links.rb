module Links
  extend ActiveSupport::Concern

  included do
    delegate :url_helpers, to: 'Rails.application.routes'
    alias :h :url_helpers  
  end

  class_methods do
    def uris(*args)
      args.each do |action|
        define_method("#{action}_url") do 
          h.send :"#{action}_url", get_parameterize(action)
        end
  
        define_method("#{action}_path") do 
          h.send :"#{action}_path", get_parameterize(action)
        end
      end
    end
  end

  def url
    h.send :"#{self.route}_url", parameterize
  end

  def path
    h.send :"#{self.route}_path", parameterize
  end

  def route
    self.class.name.parameterize
  end

  def parameterize
    self.id
  end

  private 
  def get_parameterize(action)
    if respond_to? :"#{action}_parameterize"
      send :"#{action}_parameterize"
    else
      parameterize
    end
  end
end