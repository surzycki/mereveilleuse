source 'https://rubygems.org'

gem 'rails',                    '4.2.0'
gem 'coffee-rails',             '~> 4.1.0'
gem 'sass-rails',               '~> 5.0'
gem 'jquery-rails'
gem 'pg'                                                  # Pg is the Ruby interface to the PostgreSQL RDBMS.
gem 'haml-rails'                                          # HTML Abstraction Markup Language - A Markup Haiku http://haml.info
gem 'uglifier',                 '>= 1.3.0'                # Ruby wrapper for UglifyJS JavaScript compressor.
gem 'jbuilder',                 '~> 2.0'                  # Create JSON structures via a Builder-style DSL
gem 'puma'                                                # A ruby web server built for concurrency http://puma.io
gem 'dotenv'                                              # Loads environment variables from `.env`.
gem 'dalli'                                               # High performance memcached client for Ruby
gem 'raygun4ruby'                                         # Find bugs before your users do
gem 'koala',                    '~> 1.11.0rc'             # A lightweight, flexible library for Facebook with support for OAuth authentication
gem 'warden'                                              # General Rack Authentication Framework
gem 'state_machine'                                       # Adds support for creating state machines for attributes on any Ruby class
gem 'bootstrap-sass'              
gem 'hologram'                                            # A markdown based documentation system for style guides.
gem 'bourbon'                                             # A lightweight mixin library for Sass. 
gem 'therubyracer'                                        # Embed the V8 Javascript Interpreter into Ruby
gem 'activeadmin',              github: 'activeadmin'
gem 'devise'

group :production do
  gem 'rails_12factor'                                    # Heroku, Makes running your Rails app easier. Based on the ideas behind 12factor.net
end

group :staging, :development, :test do
  gem 'capistrano',             '3.4.0'                   # Remote multi-server automation tool
  gem 'capistrano-rails'                                  # Rails support for Capistrano 3.x
  gem 'capistrano3-puma'                                  # Puma integration for Capistrano 3
  gem 'byebug'
  gem 'web-console',            '~> 2.0'
end

group :development, :test do
  gem 'factory_girl_rails'                                # A library for setting up Ruby objects as test data
  gem 'lograge'                                           # An attempt to tame Rails' default policy to log everything.
  gem 'hirb'                                              # A mini view framework for console/irb that's easy to use, even while under its influence.
  gem 'awesome_print'                                     # Pretty print your Ruby objects with style -- in full color and with proper indentation
end

group :test do
  gem 'guard'                                             # Guard is a command line tool to easily handle events on file system modifications
  gem 'rspec'                                             # RSpec for Rails-3+
  gem 'rspec-rails'                                       # RSpec for Rails-3+
  gem 'database_cleaner'                                  # Strategies for cleaning databases in Ruby. Can be used to ensure a clean state for testing
  gem 'spring-commands-rspec'
  gem 'spring' 
  gem 'shoulda-matchers',           require: false        # Makes tests easy on the fingers and the eyes
  gem 'guard-rspec',                require: false        # Guard::RSpec automatically run your specs (much like autotest)
end

ruby '2.2.0'
