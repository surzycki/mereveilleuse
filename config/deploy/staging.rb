# Load environment vars
require 'dotenv' ; Dotenv.load '.env.staging'

set :stage,         :staging
set :branch,        'develop'
set :rails_env,     'staging'
set :rack_env,      'staging'
set :migrate_env,   'staging'
set :migrate_target, :latest
set :puma_env,      'staging'

set :ping_target,   'https://staging-canvas.mereveilleuse.com/'

set :ssh_options, {
    keys: %w(/root/.ssh/id_rsa),
    forward_agent: true
}

server 'staging.therapeutes.com', user: 'deploy', roles: %w{web app db}


