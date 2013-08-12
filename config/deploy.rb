set :application, "SmokeStack"
set :app_server, :passenger

def get_env(name)
  val = ENV[name]
  if val
    return val.split(",")
  else
    raise "Please define a '#{name}' environment variable."
  end
end

#set :user, 'smokestack'

role_web = get_env('SMOKESTACK_ROLE_WEB')
role_app = get_env('SMOKESTACK_ROLE_APP')
role_db = get_env('SMOKESTACK_ROLE_DB')
role_worker = get_env('SMOKESTACK_ROLE_WORKER')

role(:web) { role_web }
role(:app) { role_app }
role(:db) { [role_db[0], {:primary => true}] }
role(:worker) { role_worker }

require 'bundler/capistrano'
load 'config/deploy/git'
load 'config/deploy/database_yml'
load 'config/deploy/production'
load 'config/deploy/passenger'
load 'config/deploy/worker'
