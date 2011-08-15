class GlancePackageBuilder < PackageBuilder

  after_initialize :handle_after_initialize

  def handle_after_initialize
    self.url = ENV['GLANCE_GIT_MASTER']
    self.branch = "master"
  end

end
