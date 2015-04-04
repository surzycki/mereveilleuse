# config valid only for current version of Capistrano
lock '3.4.0'

set :application,     'mereveilleuse'
set :repo_url,        'git@github.com:surzycki/mereveilleuse.git'
set :deploy_to,       '/var/www/mereveilleuse/app_facebook'

set :scm,             :git
set :log_level,       :info

set :linked_files,    %w{}
set :linked_dirs,     %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :keep_releases,   5

set :log_directory,               '/var/log/mereveilleuse/app_facebook'
set :normalize_asset_timestamps,  %{public/images public/javascripts public/stylesheets}

set :sidekiq_config, File.join(release_path, 'config', 'sidekiq.yml')

set :slack_webhook,         ENV['SLACK_WEB_HOOK_URL']
set :slack_channel,         -> { ENV['SLACK_CHANNEL'] }
set :slack_username,        -> { 'mereveilleuse' }
set :slack_run_starting,    -> { false }
set :slack_run_finished,    -> { true }
set :slack_run_failed,      -> { false }
set :slack_msg_finished,    -> { "There is a new version on #{fetch :rails_env, 'production'}" }
set :slack_icon_url,        -> { ENV['SLACK_ICON'] }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'puma:phased-restart'
    invoke 'sidekiq:rolling_restart'
  end

  after :publishing, :restart
  after :finishing,  :cleanup
  after :finishing,  'deploy:app:alive'

  after 'deploy:finished', 'airbrake:deploy'
end


