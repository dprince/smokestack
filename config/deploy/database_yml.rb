task :symlink_database_yml do
  run "ln -sf %s %s" %
    ["#{shared_path}/config/database.yml",
     "#{release_path}/config/database.yml"]
end

before "deploy:assets:precompile", :symlink_database_yml
