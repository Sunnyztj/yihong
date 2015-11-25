require 'bundler/capistrano'
set :rvm_ruby_string, '2.2.0'
require "rvm/capistrano"

load "config/recipes/base"
load "config/recipes/unicorn"
load "config/recipes/delayed_job"

default_run_options[:pty] = true
set :application, 'yihong'
set :repository,  'git@github.com:Sunnyztj/yihong.git'
set :scm, :git

set :deploy_to,   '/home/deploy/yihong'
set :user,        'deploy'
set :branch,      'master'
set :rails_env,   'production'
set :migrate_env, 'production'
set :use_sudo, false
set :deploy_via, :remote_cache
set :db_local_clean, true
set :locals_rails_env, "development"
set :server_address, "yi-hong.adelaideacupuncture.com.au"

server "45.79.187.10", :app, :web, :db, :primary => true
# server "yihong.com.au", :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
after 'deploy:restart', 'unicorn:restart'

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end  
  task :stop do ; end  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd '/home/deploy/yihong/current' ; bundle exec rake db:drop db:create db:migrate db:seed RAILS_ENV=production"
  end
end