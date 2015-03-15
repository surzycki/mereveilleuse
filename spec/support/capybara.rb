require 'capybara/rails'
require 'capybara/rspec'
require 'turnip/capybara'

def screenshot
  page.save_screenshot('tmp/capybara/screenshot.png')
end