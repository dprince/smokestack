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
        if smoke_test.nova_package_builder.branch then
          'Nova: ' + smoke_test.nova_package_builder.branch
        else
          'Nova: master'
        end
      when 'glance' then
        if smoke_test.glance_package_builder.branch then
          'Glance: ' + smoke_test.glance_package_builder.branch
        else
          'Glance: master'
        end
      when 'keystone' then
        if smoke_test.keystone_package_builder.branch then
          'Keystone: ' + smoke_test.keystone_package_builder.branch
        else
          'Keystone: master'
        end
      when 'swift' then
        if smoke_test.swift_package_builder.branch then
          'Swift: ' + smoke_test.swift_package_builder.branch
        else
          'Swift: master'
        end
      when 'cinder' then
        if smoke_test.cinder_package_builder.branch then
          'Cinder: ' + smoke_test.cinder_package_builder.branch
        else
          'Cinder: master'
        end
      when 'quantum' then
        if smoke_test.quantum_package_builder.branch then
          'Quantum: ' + smoke_test.quantum_package_builder.branch
        else
          'Quantum: master'
        end
      else ': master'
    end 

  end

end
