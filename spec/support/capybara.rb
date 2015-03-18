require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'turnip/capybara'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app)
end

Capybara.javascript_driver = :poltergeist

def screenshot
  page.save_screenshot('tmp/capybara/screenshot.png')
end
