set :stage,         :production
set :branch,        'master'
set :rails_env,     'production'
set :rack_env,      'production'
set :migrate_env,   'production'
set :migrate_target, :latest
set :puma_env,      'production'

set :ssh_options, {
    keys: %w(/root/.ssh/id_rsa),
    forward_agent: true
}

server 'app002.therapeutes.com', user: 'deploy', roles: %w{web app db}


