require 'erubis'
require 'tempfile'
require 'open4'

class Job < ActiveRecord::Base

  validates_presence_of :job_group_id
  belongs_to :job_group
  belongs_to :config_template
  belongs_to :approved_by_user, :class_name => "User", :foreign_key => "approved_by"
  after_initialize :handle_after_init
  after_save :handle_after_save

  def handle_after_init
    if new_record? then
      self.status = "Pending"
    end
  end

  def handle_after_save
    self.job_group.update_status
  end

  def self.run_job(job, template_name="vpc_runner.sh.erb", script_text=nil)
    job.update_attribute(:status, "Running")

    begin

      if script_text.nil?
        script_text = File.read(File.join(Rails.root, "app", "templates", "common.sh"))
        template = File.read(File.join(Rails.root, "app", "templates", template_name))
        eruby = Erubis::Eruby.new(template)
        script_text += eruby.result(:job => job)
      end

      script_file=Tempfile.new('smokestack')
      script_file.write(script_text)
      script_file.flush

      #chef_installer.yml
      chef_installer_text = ""
      unless job.config_template.nil?
        chef_template = File.read(File.join(Rails.root, "app", "templates", "chef_installer.yml.erb"))
        eruby = Erubis::Eruby.new(chef_template)
        chef_installer_text=eruby.result(:job => job)
      end
      chef_installer_file=Tempfile.new('smokestack_chef')
      chef_installer_file.write(chef_installer_text)
      chef_installer_file.flush

      #nodes.json
      nodes_json_file=Tempfile.new('smokestack_nodes_json')
      unless job.config_template.nil?
        nodes_json_file.write(job.config_template.nodes_json)
      end
      nodes_json_file.flush

      #server_group.json
      server_group_json_file=Tempfile.new('smokestack_server_group_json')
      unless job.config_template.nil?
        server_group_json_file.write(job.config_template.server_group_json)
      end
      server_group_json_file.flush

      nova_builder=job.job_group.smoke_test.nova_package_builder
      nova_packager_url=nova_builder.packager_url
      if nova_packager_url.blank? then
        nova_packager_url=ENV['NOVA_DEB_PACKAGER_URL']
      end

      glance_builder=job.job_group.smoke_test.glance_package_builder
      glance_packager_url=glance_builder.packager_url
      if glance_packager_url.blank? then
        glance_packager_url=ENV['GLANCE_DEB_PACKAGER_URL']
      end

      keystone_builder=job.job_group.smoke_test.keystone_package_builder
      keystone_packager_url=keystone_builder.packager_url
      if keystone_packager_url.blank? then
        keystone_packager_url=ENV['KEYSTONE_DEB_PACKAGER_URL']
      end

      args = ["bash",
        script_file.path,
        nova_builder.url,
        nova_builder.branch || "",
        nova_builder.merge_trunk.to_s,
        nova_builder.revision_hash,
        nova_packager_url,
        keystone_builder.url,
        keystone_builder.branch || "",
        keystone_builder.merge_trunk.to_s,
        keystone_builder.revision_hash,
        keystone_packager_url,
        glance_builder.url,
        glance_builder.branch || "",
        glance_builder.merge_trunk.to_s,
        glance_builder.revision_hash,
        glance_packager_url,
        chef_installer_file.path,
        nodes_json_file.path,
        server_group_json_file.path]

      status = Open4::popen4(*args) do |pid, stdin, stdout, stderr|
        stdin.close 
        job.stdout=stdout.readlines.join.chomp
        job.stderr=stderr.readlines.join.chomp

        job.nova_revision=Job.parse_nova_revision(job.stdout)
        job.glance_revision=Job.parse_glance_revision(job.stdout)
        job.keystone_revision=Job.parse_keystone_revision(job.stdout)
        job.msg=Job.parse_last_message(job.stdout)
        job.save
      end
      if status.exitstatus == 0
        job.update_attribute(:status, "Success")
        return true
      else
        job.update_attribute(:status, "Failed")
        return false
      end

      script_file.close
    rescue Exception => e
      job.update_attribute(:msg, e.message)
      job.update_attribute(:status, "Failed")
      raise e
    end

  end

  def self.parse_nova_revision(stdout)
    stdout.each_line do |line|
      if line =~ /^NOVA_REVISION/ then
        return line.sub(/^NOVA_REVISION=/, "").chomp
      end
    end
    return ""
  end

  def self.parse_glance_revision(stdout)
    stdout.each_line do |line|
      if line =~ /^GLANCE_REVISION/ then
        return line.sub(/^GLANCE_REVISION=/, "").chomp
      end
    end
    return ""
  end

  def self.parse_keystone_revision(stdout)
    stdout.each_line do |line|
      if line =~ /^KEYSTONE_REVISION/ then
        return line.sub(/^KEYSTONE_REVISION=/, "").chomp
      end
    end
    return ""
  end

  def self.parse_last_message(stdout)
    failure_msg=""
    stdout.each_line do |line|
      if line =~ /^FAILURE_MSG/ then
        failure_msg = line.sub(/^FAILURE_MSG=/, "").chomp
      end
    end
    return failure_msg
  end

end
