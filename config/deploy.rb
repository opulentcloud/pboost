# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'pboostv2'
set :repo_url, 'git@github.com:markysharky70/pboostv2.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets/bootstrap}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rails_env, "production"
set :deploy_via, :copy
set :rbenv_type, :user
set :rbenv_ruby, '2.1.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

namespace :assets do
  desc "Precompile assets locally and then rsync to web servers"
  task :precompile do
    on roles(:web) do
      rsync_host = host.to_s # this needs to be done outside run_locally in order for host to exist
      run_locally do
        with rails_env: fetch(:stage) do
          execute :bundle, "exec rake assets:precompile"
        end
        execute "rsync -av --delete ./public/assets/ #{fetch(:user)}@#{rsync_host}:#{shared_path}/public/assets/"
        execute "rm -rf public/assets"
        # execute "rm -rf tmp/cache/assets" # in case you are not seeing changes
      end
    end
  end
end

namespace :deploy do
  after :updated, "assets:precompile"

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "unicorn: start"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

