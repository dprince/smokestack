task :symlink_production_rb do
  run "ln -sf %s %s" %
    ["#{shared_path}/config/environments/production.rb",
     "#{release_path}/config/environments/production.rb"]
end

before "deploy:assets:precompile", :symlink_production_rb
