require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load environment vars
require 'dotenv' ; Dotenv.load '.env.local', ".env.#{Rails.env}"

module AppFacebook
  class Application < Rails::Application
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

    # react js
    config.react.variant      = :production
    config.react.addons       = true
  end
end
