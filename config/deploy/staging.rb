set :stage,         :staging
set :branch,        'develop'
set :rails_env,     'staging'
set :rack_env,      'staging'
set :migrate_env,   'staging'
set :migrate_target, :latest
set :puma_env,      'staging'

set :ssh_options, {
    keys: %w(/var/lib/jenkins/.ssh/id_rsa),
    forward_agent: true
}

server 'staging.therapeutes.com', user: 'deploy', roles: %w{web app db}


