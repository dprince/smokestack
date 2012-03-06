set :repository, ENV['DEPLOY_REPO'] || 'git://github.com/dprince/smokestack.git'
set :scm, :git
set :branch, ENV['DEPLOY_BRANCH'] || 'master'

set :deploy_via, :remote_cache

namespace :deploy do
  desc "Show current SHA"
  task :show_revision do
    puts "Current revision: #{current_revision}"
  end
end
