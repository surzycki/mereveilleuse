# link.rb URL works outside of views add a default host in an initializer:
Rails.application.routes.default_url_options[:host]= ENV['MEREVEILLEUSE_HOST']