module SmokeTestsHelper

  def config_template_checked(config_template)

    if @smoke_test and @smoke_test.config_templates
      return @smoke_test.config_templates.include?(config_template)
    else
      false
    end

  end

  def test_suite_checked(suite)

    if @smoke_test.new_record? then
      return suite.enabled?
    end

    if @smoke_test and @smoke_test.test_suites
      return @smoke_test.test_suites.include?(suite)
    else
      false 
    end

  end

  def project_branch_name(smoke_test)

    return '' if smoke_test.nil?

    project = smoke_test.project

    return ': master' if project.nil?

    return case project
      when 'nova' then
        builder = smoke_test.package_builders.select{|x| x.type == 'NovaPackageBuilder'}[0]
        if builder then
          'Nova: ' + builder.branch
        else
          'Nova: master'
        end
      when 'glance' then
        builder = smoke_test.package_builders.select{|x| x.type == 'GlancePackageBuilder'}[0]
        if builder then
          'Glance: ' + builder.branch
        else
          'Glance: master'
        end
      when 'keystone' then
        builder = smoke_test.package_builders.select{|x| x.type == 'KeystonePackageBuilder'}[0]
        if builder then
          'Keystone: ' + builder.branch
        else
          'Keystone: master'
        end
      when 'swift' then
        builder = smoke_test.package_builders.select{|x| x.type == 'SwiftPackageBuilder'}[0]
        if builder then
          'Swift: ' + builder.branch
        else
          'Swift: master'
        end
      when 'cinder' then
        builder = smoke_test.package_builders.select{|x| x.type == 'CinderPackageBuilder'}[0]
        if builder then
          'Cinder: ' + builder.branch
        else
          'Cinder: master'
        end
      when 'neutron' then
        builder = smoke_test.package_builders.select{|x| x.type == 'NeutronPackageBuilder'}[0]
        if builder then
          'Neutron: ' + builder.branch
        else
          'Neutron: master'
        end
      when 'ceilometer' then
        builder = smoke_test.package_builders.select{|x| x.type == 'CeilometerPackageBuilder'}[0]
        if builder then
          'Ceilometer: ' + builder.branch
        else
          'Ceilometer: master'
        end
      when 'heat' then
        builder = smoke_test.package_builders.select{|x| x.type == 'HeatPackageBuilder'}[0]
        if builder then
          'Heat: ' + builder.branch
        else
          'Heat: master'
        end
      when 'puppet-nova' then
        conf_module = smoke_test.config_modules.select{|x| x.type == 'NovaConfigModule'}[0]
        if conf_module then
          'Puppet Nova: ' + conf_module.branch
        else
          'Puppet Nova: master'
        end
      when 'puppet-glance' then
        conf_module = smoke_test.config_modules.select{|x| x.type == 'GlanceConfigModule'}[0]
        if conf_module then
          'Puppet Glance: ' + conf_module.branch
        else
          'Puppet Glance: master'
        end
      when 'puppet-keystone' then
        conf_module = smoke_test.config_modules.select{|x| x.type == 'KeystoneConfigModule'}[0]
        if conf_module then
          'Puppet Keystone: ' + conf_module.branch
        else
          'Puppet Keystone: master'
        end
      when 'puppet-swift' then
        conf_module = smoke_test.config_modules.select{|x| x.type == 'SwiftConfigModule'}[0]
        if conf_module then
          'Puppet Swift: ' + conf_module.branch
        else
          'Puppet Swift: master'
        end
      when 'puppet-cinder' then
        conf_module = smoke_test.config_modules.select{|x| x.type == 'CinderConfigModule'}[0]
        if conf_module then
          'Puppet Cinder: ' + conf_module.branch
        else
          'Puppet Cinder: master'
        end
      when 'puppet-neutron' then
        conf_module = smoke_test.config_modules.select{|x| x.type == 'NeutronConfigModule'}[0]
        if conf_module then
          'Puppet Neutron: ' + conf_module.branch
        else
          'Puppet Neutron: master'
        end
      when 'puppet-ceilometer' then
        conf_module = smoke_test.config_modules.select{|x| x.type == 'CeilometerConfigModule'}[0]
        if conf_module then
          'Puppet Ceilometer: ' + conf_module.branch
        else
          'Puppet Ceilometer: master'
        end
      when 'puppet-heat' then
        conf_module = smoke_test.config_modules.select{|x| x.type == 'HeatConfigModule'}[0]
        if conf_module then
          'Puppet Heat: ' + conf_module.branch
        else
          'Puppet Heat: master'
        end
      else ': master'
    end 

  end

  #has this builder been modified from default settings
  def is_builder_stock(package_builder)
    if package_builder.new_record? then
      return true
    else
      builder_type = package_builder.type.chomp('PackageBuilder').upcase
      return false if package_builder.url != ENV["#{builder_type}_GIT_MASTER"]
      return false if package_builder.branch != 'master'
      return false if not package_builder.packager_url.blank?
      return false if not package_builder.packager_branch.blank?
      return false if not package_builder.revision_hash.blank?
    end
    return true
  end

  #has this config_module been modified from default settings
  def is_config_module_stock(config_module)
    if config_module.new_record? then
      return true
    else
      conf_module_type = config_module.type.chomp('ConfigModule').upcase
      return false if config_module.url != ENV["PUPPET_#{conf_module_type}_GIT_MASTER"]
      return false if config_module.branch != 'master'
      return false if not config_module.revision_hash.blank?
    end
    return true
  end

end
