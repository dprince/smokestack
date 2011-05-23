class SmokeTest < ActiveRecord::Base
  has_and_belongs_to_many :config_templates
end

class ConfigTemplate < ActiveRecord::Base
  has_and_belongs_to_many :smoke_tests
end

class UpdateSmokeTests2 < ActiveRecord::Migration

  def self.up

    config_template = ConfigTemplate.find(:first)
    SmokeTest.find(:all).each do |smoke_test|
      smoke_test.config_templates << config_template
      smoke_test.save
    end

  end

  def self.down

    SmokeTest.find(:all).each do |smoke_test|
      smoke_test.config_templates.clear
      smoke_test.save
    end

  end

end
