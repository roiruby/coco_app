# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, 'cocomelo_app'

set :repo_url, 'https://github.com/roiruby/coco_app.git'

set :branch, 'main'

set :deploy_to, '/var/www/coco_app'

set :linked_files, fetch(:linked_files, []).push("config/master.key")

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :keep_releases, 5

set :rbenv_ruby, '2.5.3'

set :log_level, :debug

namespace :deploy do

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
  
  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          sql = "CREATE DATABASE IF NOT EXISTS coco_app_production;"
          execute "mysql --user=root --password=Cocomysql1! -e '#{sql}'"
         end
      end
    end
  end
  
  desc 'db_seed_fu'
  task :db_seed_fu do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed_fu'
        end
      end
    end
  end
  
  desc 'Generate sitemap'
  task :sitemap do
    on roles(:app) do
      within release_path do
        execute :bundle, :exec, :rake, 'sitemap:create RAILS_ENV=production'
      end
    end
  end

  after  'deploy:restart', 'deploy:sitemap'

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end