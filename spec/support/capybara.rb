require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'turnip/capybara'
require 'capybara/email/rspec'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, { debug: false, js_errors: false })
end

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true)
end

Capybara.javascript_driver = :poltergeist

# set the app_host so we can click urls in our integration tests
Capybara.server_port = 3001
Capybara.app_host = "http://#{ENV['MEREVEILLEUSE_HOST']}:3001"
