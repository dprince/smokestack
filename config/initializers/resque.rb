Resque.after_fork = Proc.new {
  ActiveRecord::Base.connection_handler.verify_active_connections!
}
