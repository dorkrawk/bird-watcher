require "rvm/capistrano"
require "bundler/capistrano"

set :application, "bird_watcher"
set :repository,  "https://github.com/dorkrawk/bird-watcher.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "zoidberg"                          # Your HTTP server, Apache/etc
role :app, "zoidberg"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :deploy_to, "/var/www/bird_watcher"
# set :deploy_via, :remote_cache

set :user, "dave"
# Don't use sudo when running the commands
set :use_sudo, false

# Forward public keys for GitHub etc. authentication.
# Prevents us having deployment server public keys.
ssh_options[:forward_agent] = true

# After an initial (cold) deploy, symlink the app and restart nginx
after "deploy:cold" do
  admin.symlink_config
  admin.nginx_restart
end

# As this isn't a rails app, we don't start and stop the app invidually
namespace :deploy do
  desc "Not starting as we're running passenger."
  task :start do
  end

  desc "Not stopping as we're running passenger."
  task :stop do
  end

  desc "Restart the app."
  task :restart, roles: :app, except: { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # This will make sure that Capistrano doesn't try to run rake:migrate (this is not a Rails project!)
  task :cold do
    deploy.update
    deploy.start
  end
end

# These task are used for un/symlinking the app, and restarting the server (nginx)
namespace :admin do
  desc "Restart nginx."
  task :nginx_restart, roles: :app do
    run "#{sudo} service nginx restart"
  end
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end