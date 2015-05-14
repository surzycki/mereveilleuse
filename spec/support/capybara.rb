require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'turnip/capybara'
require 'capybara/email/rspec'
require 'capybara-screenshot/rspec'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, { debug: false, js_errors: false })
end

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true)
end

Capybara.javascript_driver = :poltergeist

Capybara::Screenshot.webkit_options   = { width: 1024, height: 768 }
Capybara::Screenshot.append_timestamp = false
Capybara.save_and_open_page_path      = "#{Rails.root}/public"

# set the app_host so we can click urls in our integration tests
Capybara.server_port = 3001
Capybara.app_host = "http://#{ENV['MEREVEILLEUSE_HOST']}:3001"

RSpec.configure do |config|
  config.before(:each, file_path: %r(spec/acceptance) ) do 
    # match the same port that capybara is running on to allow us to 
    # click links in integration tests
    Rails.application.routes.default_url_options[:port] = 3001 
    Rails.application.config.action_mailer.default_url_options[:port] = 3001 
  end

  config.after(:each, file_path: %r(spec/acceptance) ) do 
    # Remove for other example groups as this is a singleton
    Rails.application.routes.default_url_options.delete(:port)
    Rails.application.config.action_mailer.default_url_options.delete(:port) 
  end
end
