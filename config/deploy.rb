default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "pboost"
set :repository, "git@heroku.com:pboost.git"
set :user, "netadm"
set :sudo_password, "sudo password: "

# If you have previously been relying upon the code to start, stop 
# and restart your mongrel application, or if you rely on the database
# migration code, please uncomment the lines you require below

# If you are deploying a rails app you probably need these:

# load 'ext/rails-database-migrations.rb'
# load 'ext/rails-shared-directories.rb'

# There are also new utility libaries shipped with the core these 
# include the following, please see individual files for more
# documentation, or run `cap -vT` with the following lines commented
# out to see what they make available.

# load 'ext/spinner.rb'              # Designed for use with script/spin
# load 'ext/passenger-mod-rails.rb'  # Restart task for use with mod_rails
# load 'ext/web-disable-enable.rb'   # Gives you web:disable and web:enable

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

#this config is for a local deployment
#set :copy_strategy, :export
#set :copy_cache, true
#set :copy_cache, "/tmp/caches/pboost"
#set :copy_exclude, [".git/*"]
#set :copy_compression, :gzip

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :scm_username, "mark@wilsonsdev.com"
set :deploy_via, :remote_cache
set :branch, "wswithmap"
# see a full list by running "gem contents capistrano | grep 'scm/'"

#role :web, "your web-server here"
server "190.124.41.8 ", :app, :web, :db, :primary => true

namespace :config do
	desc "Link in config files"
	task :link do
		run "rm -f #{current_path}/config/database.yml && ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{current_path}/config/database.yml"
		run "rm -f #{current_path}/config/email.yml && ln -nfs #{deploy_to}/#{shared_dir}/config/email.yml #{current_path}/config/email.yml"
	end
end

namespace :prawn do
	desc "Link in prawn"
	task :link do
		run "rm -f #{current_path}/vendor/prawn && ln -nfs #{deploy_to}/#{shared_dir}/vendor/prawn #{current_path}/vendor/prawn"
	end
end

namespace :docs do
	desc "Link in docs directory for pdf gen"
	task :link do
		run "rm -f #{current_path}/docs && ln -nfs #{deploy_to}/#{shared_dir}/docs #{current_path}/docs"
	end
end

namespace :delayed_job do
	desc "Start delayed_job process"
	task :start, :roles => :app do
		run "#{sudo} RAILS_ENV=production #{current_path}/script/delayed_job start"
	end
	
	desc "Stop delayed_job process"
	task :stop, :roles => :app do
		run "#{sudo} RAILS_ENV=production #{current_path}/script/delayed_job stop"
	end
	
	desc "Restart delayed_job process"
	task :restart, :roles => :app do
		run "#{sudo} RAILS_ENV=production #{current_path}/script/delayed_job restart"
	end

end

after :deploy, "config:link"
after :deploy, "prawn:link"
after :deploy, "docs:link"
after :deploy, "delayed_job:stop"
after :deploy, "delayed_job:start"

deploy.task :restart, :roles => :app do
	desc "Restart application"
	run "touch #{current_path}/tmp/restart.txt"
end


