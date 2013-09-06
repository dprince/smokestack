Smokestack::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
end

ENV['NOVA_GIT_MASTER'] = "git://github.com/openstack/nova.git"
ENV['NOVACLIENT_GIT_MASTER'] = "git://github.com/openstack/python-novaclient.git"
ENV['GLANCE_GIT_MASTER'] = "git://github.com/openstack/glance.git"
ENV['GLANCECLIENT_GIT_MASTER'] = "git://github.com/openstack/python-glanceclient.git"
ENV['KEYSTONE_GIT_MASTER'] = "git://github.com/openstack/keystone.git"
ENV['KEYSTONECLIENT_GIT_MASTER'] = "git://github.com/openstack/python-keystoneclient.git"
ENV['SWIFT_GIT_MASTER'] = "git://github.com/openstack/swift.git"
ENV['SWIFTCLIENT_GIT_MASTER'] = "git://github.com/openstack/python-swiftclient.git"
ENV['CINDER_GIT_MASTER'] = "git://github.com/openstack/cinder.git"
ENV['CINDERCLIENT_GIT_MASTER'] = "git://github.com/openstack/python-cinderclient.git"
ENV['NEUTRON_GIT_MASTER'] = "git://github.com/openstack/neutron.git"
ENV['NEUTRONCLIENT_GIT_MASTER'] = "git://github.com/openstack/python-neutronclient.git"
ENV['CEILOMETER_GIT_MASTER'] = "git://github.com/openstack/ceilometer.git"
ENV['CEILOMETERCLIENT_GIT_MASTER'] = "git://github.com/openstack/python-ceilometerclient.git"
ENV['HEAT_GIT_MASTER'] = "git://github.com/openstack/heat.git"
ENV['HEATCLIENT_GIT_MASTER'] = "git://github.com/openstack/python-heatclient.git"

ENV['FIRESTACK_URL'] = "git://github.com/dprince/firestack.git"

# Default packager URLS use Fedora
# NOTE: you can override/set these in your distro specific environments
ENV['NOVA_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-nova.git"
ENV['NOVACLIENT_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-python-novaclient.git"
ENV['GLANCE_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-glance.git"
ENV['GLANCECLIENT_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-python-glanceclient.git"
ENV['KEYSTONE_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-keystone.git"
ENV['KEYSTONECLIENT_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-python-keystoneclient.git"
ENV['SWIFT_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-swift.git"
ENV['SWIFTCLIENT_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-python-swiftclient.git"
ENV['CINDER_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-cinder.git"
ENV['CINDERCLIENT_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-python-cinderclient.git"
ENV['NEUTRON_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-neutron.git"
ENV['NEUTRONCLIENT_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-python-neutronclient.git"
ENV['CEILOMETER_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-ceilometer.git"
ENV['CEILOMETERCLIENT_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-python-ceilometerclient.git"
ENV['HEAT_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-heat.git"
ENV['HEATCLIENT_PACKAGER_URL'] = "git://github.com/redhat-openstack/openstack-python-heatclient.git"

# Config modules
# NOTE: these default to upstream stackforge puppet modules but could
# certainly be used with other config management choices as well.
ENV['PUPPET_NOVA_GIT_MASTER'] = "git://github.com/stackforge/puppet-nova.git"
ENV['PUPPET_GLANCE_GIT_MASTER'] = "git://github.com/stackforge/puppet-glance.git"
ENV['PUPPET_KEYSTONE_GIT_MASTER'] = "git://github.com/stackforge/puppet-keystone.git"
ENV['PUPPET_SWIFT_GIT_MASTER'] = "git://github.com/stackforge/puppet-swift.git"
ENV['PUPPET_CINDER_GIT_MASTER'] = "git://github.com/stackforge/puppet-cinder.git"
ENV['PUPPET_NEUTRON_GIT_MASTER'] = "git://github.com/stackforge/puppet-neutron.git"
ENV['PUPPET_CEILOMETER_GIT_MASTER'] = "git://github.com/stackforge/puppet-ceilometer.git"
ENV['PUPPET_HEAT_GIT_MASTER'] = "git://github.com/stackforge/puppet-heat.git"
ENV['PASTE_SITE_URL'] = "http://paste.openstack.org/"
ENV['METRICS_DATA_FILE'] = "/tmp/smokestack_metrics.txt"
