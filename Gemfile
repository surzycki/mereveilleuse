source 'https://rubygems.org'

gem 'rails',                    '4.2.1'
gem 'coffee-rails',             '~> 4.1.0'
gem 'sass-rails',               '5.0.3'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'pg'                                                  # Pg is the Ruby interface to the PostgreSQL RDBMS.
gem 'haml-rails'                                          # HTML Abstraction Markup Language - A Markup Haiku http://haml.info
gem 'uglifier',                 '>= 1.3.0'                # Ruby wrapper for UglifyJS JavaScript compressor.
gem 'jbuilder',                 '~> 2.0'                  # Create JSON structures via a Builder-style DSL
gem 'puma'                                                # A ruby web server built for concurrency http://puma.io
gem 'dotenv'                                              # Loads environment variables from `.env`.
gem 'dalli'                                               # High performance memcached client for Ruby
gem 'airbrake'                                            # Find bugs before your users do
gem 'koala',                    '~> 1.11.0rc'             # A lightweight, flexible library for Facebook with support for OAuth authentication
gem 'rails-settings-cached',    '0.4.1'                   # This is imporved from rails-settings, added caching for all settings
gem 'warden'                                              # General Rack Authentication Framework
gem 'state_machine'                                       # Adds support for creating state machines for attributes on any Ruby class
gem 'bootstrap-sass'              
gem 'hologram'                                            # A markdown based documentation system for style guides.
gem 'bourbon'                                             # A lightweight mixin library for Sass. 
gem 'therubyracer'                                        # Embed the V8 Javascript Interpreter into Ruby
gem 'namae'                                               # Namae (名前) parses personal names and splits them into their component parts.
gem 'searchkick'                                          # Intelligent search made easy
gem 'nokogiri'                                            # Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser with XPath and CSS selector support.
gem 'geocoder'                                            # Complete Ruby geocoding solution
gem 'redis'                                               # A Ruby client library for Redis
gem 'wisper'                                              # A micro library providing Ruby objects with Publish-Subscribe capabilities
gem 'sidekiq'                                             # Simple, efficient background processing for Ruby.
gem 'premailer-rails'                                     # CSS styled emails without the hassle.
gem 'monadic'                                             # helps dealing with exceptional situations, 
gem 'time_difference'                                     # The missing Ruby method to print out time difference (duration) in year, month, week, day, hour, minute, and second.
gem 'slack-notifier'                                      # A simple wrapper for posting to slack channels
gem 'devise'                                              # (necessary for activeadmin)
gem 'browser'                                             # Do some browser detection with Ruby. Includes ActionController integration.
gem 'omniauth-facebook'                                   # Facebook OAuth2 Strategy for OmniAuth 
gem 'unicode_utils'


gem 'react-rails',    '~> 1.0'
gem 'activeadmin',                 github: 'activeadmin'
gem 'canonical-rails',             github: 'jumph4x/canonical-rails'

gem 'sinatra',           require: nil
gem 'google-api-client', require: 'google/api_client'

group :production do
  gem 'rails_12factor'                                    # Heroku, Makes running your Rails app easier. Based on the ideas behind 12factor.net
end

group :staging, :development, :test do
  gem 'capistrano',             '3.4.0'                   # Remote multi-server automation tool
  
  gem 'capistrano3-puma'                                  # Puma integration for Capistrano 3
  gem 'capistrano-sidekiq'                                # Sidekiq integration for Capistrano
  gem 'forgery'                                           # Easy and customizable generation of forged data.
  gem 'byebug'
  gem 'web-console',            '~> 2.0'
  gem 'slackistrano', require: false                      # Slack integration for Capistrano deployments.

  gem 'capistrano-rails', github: 'capistrano/rails'      # Rails support for Capistrano 3.x
end

group :development, :test do
  gem 'factory_girl_rails'                                # A library for setting up Ruby objects as test data
  gem 'lograge'                                           # An attempt to tame Rails' default policy to log everything.
  gem 'hirb'                                              # A mini view framework for console/irb that's easy to use, even while under its influence.
  gem 'awesome_print'                                     # Pretty print your Ruby objects with style -- in full color and with proper indentation
end

group :test do
  gem 'capybara'                                          # Acceptance test framework for web application
  gem 'capybara-email'                                    # Test your ActionMailer and Mailer messages with Capybara
  gem 'turnip'                                            # Gherkin extension for RSpec
  gem 'guard'                                             # Guard is a command line tool to easily handle events on file system modifications
  gem 'rspec'                                             # RSpec for Rails-3+
  gem 'rspec-rails'                                       # RSpec for Rails-3+
  gem 'email_spec'                                        # Collection of RSpec/MiniTest matchers and Cucumber steps for testing email in a ruby app using ActionMailer or Pony
  gem 'database_cleaner'                                  # Strategies for cleaning databases in Ruby. Can be used to ensure a clean state for testing
  gem 'spring-commands-rspec'
  gem 'spring',                     '1.3.5' 
  gem 'poltergeist'                                       # A PhantomJS driver for Capybara
  gem 'webmock'                                           # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem 'rspec-activejob'                                   # RSpec matchers for testing ActiveJob
  gem 'capybara-screenshot'
  gem 'wisper-rspec',               require: false        # RSpec matchers and stubbing for Wisper
  gem 'shoulda-matchers',           require: false        # Makes tests easy on the fingers and the eyes
  gem 'guard-rspec',                require: false        # Guard::RSpec automatically run your specs (much like autotest)
end

ruby '2.2.2'
