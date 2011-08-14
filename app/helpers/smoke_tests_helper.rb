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

end
