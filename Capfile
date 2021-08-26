require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/rbenv"
require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"
require "capistrano/scm/git"
require 'capistrano/rails/console'

install_plugin Capistrano::SCM::Git

Dir.glob("lib/capistrano/tasks/*.rb").each { |r| import r }