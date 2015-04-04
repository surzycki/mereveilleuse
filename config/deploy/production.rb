set :stage,         :production
set :branch,        'master'
set :rails_env,     'production'
set :rack_env,      'production'
set :migrate_env,   'production'
set :migrate_target, :latest
set :puma_env,      'production'

set :ping_target,   'https://canvas.mereveilleuse.com/'

set :slack_webhook,         ENV['SLACK_WEB_HOOK_URL']
set :slack_channel,         -> { ENV['SLACK_CHANNEL'] }
set :slack_username,        -> { 'mereveilleuse' }
set :slack_run_starting,    -> { false }
set :slack_run_finished,    -> { true }
set :slack_run_failed,      -> { false }
set :slack_msg_finished,    -> { "There is a new version on #{fetch :rails_env, 'production'}" }
set :slack_icon_url,        -> { ENV['SLACK_ICON'] }


set :ssh_options, {
    keys: %w(/root/.ssh/id_rsa),
    forward_agent: true
}

server 'app002.therapeutes.com', user: 'deploy', roles: %w{web app db}


