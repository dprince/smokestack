module SmokeTestsHelper

  def config_template_checked(config_template)

    if @smoke_test and @smoke_test.config_templates
      return @smoke_test.config_templates.include?(config_template)
    else
      false
    end

  end
end
