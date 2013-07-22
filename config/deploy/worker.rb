namespace :worker do

  desc "Reload all workers after code update."
  task :reload, :roles => :worker do
    run "#{current_path}/script/stop_workers"
  end

end

after "deploy", "worker:reload"
