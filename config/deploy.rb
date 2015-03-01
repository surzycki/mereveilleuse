# config valid only for current version of Capistrano
lock '3.3.5'

set :application,     'mereveilleuse'
set :repo_url,        'git@github.com:surzycki/mereveilleuse.git'
set :deploy_to,       '/var/www/mereveilleuse/app_facebook'

set :scm,             :git
set :log_level,       :debug

set :linked_files,    %w{}
set :linked_dirs,     %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :keep_releases,   5

set :log_directory,               '/var/log/mereveilleuse/app_facebook'
set :normalize_asset_timestamps,  %{public/images public/javascripts public/stylesheets}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'puma:stop'
    invoke 'puma:start'
  end

  after :finishing, 'deploy:cleanup'
end
