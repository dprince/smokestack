namespace :passenger do

  desc "restart passenger"  
  task :restart, :roles => :web do  
    run "touch #{File.join(current_path,'tmp','restart.txt')}"  
  end

end

after :deploy, "passenger:restart"
