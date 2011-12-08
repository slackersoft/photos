require 'bundler/capistrano'

set :user, "whiteguy013"
set :domain, "greggandjen.com"
set :project, "photos"
set :application, "photos.greggandjen.com"
set :applicationdir, "/home/#{user}/#{application}"

set :repository,  "git://github.com/gvanhove/photos.git"
set :scm, :git

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

set :deploy_to, applicationdir
set :deploy_via, :remote_cache

set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

set :use_sudo, false

namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

namespace :deploy do
  namespace :db do
    task :symlink, :except => { :no_release => true } do
      run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    end
    
    after "deploy:finalize_update", "deploy:db:symlink"
  end
end
