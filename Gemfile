source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails',            '4.2.0'
gem 'coffee-rails',     '~> 4.1.0'
gem 'sass-rails',       '~> 5.0'
gem 'therubyracer'
gem 'jquery-rails'
gem 'pg'                                                  # Pg is the Ruby interface to the PostgreSQL RDBMS.
gem 'haml-rails'                                          # HTML Abstraction Markup Language - A Markup Haiku http://haml.info
gem 'uglifier',         '>= 1.3.0'                        # Ruby wrapper for UglifyJS JavaScript compressor.
gem 'jbuilder',         '~> 2.0'                          # Create JSON structures via a Builder-style DSL
gem 'puma'                                                # A ruby web server built for concurrency http://puma.io

group :production do
  gem 'rails_12factor'                                     # Heroku, Makes running your Rails app easier. Based on the ideas behind 12factor.net
end

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :staging, :development, :test do
  gem 'capistrano'                                        # Remote multi-server automation tool
  gem 'capistrano-rails'                                  # Rails support for Capistrano 3.x
  gem 'byebug'
  gem 'web-console',    '~> 2.0'
  gem 'spring'
end

group :development, :test do
  gem 'factory_girl_rails'                                # A library for setting up Ruby objects as test data.
end

group :test do
  gem 'rspec'                                             # RSpec for Rails-3+
end
