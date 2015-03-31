require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load environment vars
require 'dotenv' ; Dotenv.load '.env.local', ".env.#{Rails.env}"

module AppFacebook
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib/extensions)
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.generators do |g|
      g.template_engine   :haml
      g.test_framework    :rspec, fixture: true
      g.stylesheet_engine :sass
      g.fixture_replacement :factory_girl
    end

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # set cache store using dalli driver
    #config.cache_store = :dalli_store

    # for custom error pages
    config.exceptions_app = self.routes

    # change field with errors behaviour
    config.action_view.field_error_proc = Proc.new do |html_tag, instance| 
      return if html_tag.blank?
      
      node = Nokogiri::HTML::fragment(html_tag).children.first
      node['data-error'] = true
      node.to_html.html_safe
    end

    # react js
    config.react.variant      = :production
    config.react.addons       = true

    # email
    config.action_mailer.delivery_method     = :smtp
    config.action_mailer.smtp_settings       = { 
      address:         ENV['MEREVEILLEUSE_SMTP_HOST'], 
      port:            ENV['MEREVEILLEUSE_SMTP_PORT'],
      user_name:       ENV['MEREVEILLEUSE_SMTP_USERNAME'],
      password:        ENV['MEREVEILLEUSE_SMTP_PASSWORD'],
      domain:          ENV['MEREVEILLEUSE_SMTP_DOMAIN'],
      authentication:  :plain,
      enable_starttls_auto: true
    }
    config.action_mailer.default_url_options = { host: ENV['MEREVEILLEUSE_HOST'] }
  
    #config.roadie.url_options = { host: ENV['MEREVEILLEUSE_HOST'], scheme: ENV['MEREVEILLEUSE_PROTOCOL'] }
  end
end
