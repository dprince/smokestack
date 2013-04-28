class NovaPackageBuilder < PackageBuilder

  after_initialize :handle_after_initialize

  def handle_after_initialize
    if not self.url and not self.branch then
      self.url = ENV['NOVA_GIT_MASTER']
      self.branch = "master"
    end
  end

end
