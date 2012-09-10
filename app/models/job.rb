require 'erubis'
require 'open4'
require 'fileutils'
require 'timeout'

class Job < ActiveRecord::Base

  PUPPET_LIBVIRT = "Puppet Libvirt"
  PUPPET_VPC = "Puppet Vpc"
  PUPPET_XEN = "Puppet Xen"
  JOB_TYPES = [PUPPET_LIBVIRT, PUPPET_VPC, PUPPET_XEN]

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

  def self.run_job(job, template_name="puppet_vpc_runner.sh.erb", script_text=nil)
    job.update_attributes(:status => "Running", :start_time => Time.now)


    base_dir = File.join(Dir.tmpdir, "smokestack_job_#{job.id}")
    FileUtils.mkdir_p(base_dir)
    script_file=File.join(base_dir, 'script.bash')
    server_group_json_file=File.join(base_dir, 'server_group.json')
    environment_file=File.join(base_dir, 'environment')
    node_configs_dir=File.join(base_dir, 'node_configs')

    begin

      if script_text.nil?
        common_template = File.read(File.join(Rails.root, "app", "templates", "common.sh.erb"))
        common_eruby = Erubis::Eruby.new(common_template)
        script_text = common_eruby.result(:job => job)
        
        template = File.read(File.join(Rails.root, "app", "templates", template_name))
        template_eruby = Erubis::Eruby.new(template)
        script_text += template_eruby.result(:job => job)
      end

      File.open(script_file, 'w') do |f|
        f.write(script_text)
      end

      #server_group.json
      File.open(server_group_json_file, 'w') do |f|
        unless job.config_template.nil?
          f.write(job.config_template.server_group_json)
        end
      end

      #environment
      File.open(environment_file, 'w') do |f|
        unless job.config_template.nil? or job.config_template.environment.nil?
          job.config_template.environment.each_line do |line|
            data=line.match(/(\S*)=(\S*)/)
            f.write("export #{data[1]}=\"#{data[2]}\"\n")
          end
        end
      end

      #node configs
      unless job.config_template.nil?
        job.config_template.node_configs.each do |node_config|
          FileUtils.mkdir_p(node_configs_dir)
          File.open(File.join(node_configs_dir, node_config.hostname), 'w') do |f|
            f.write node_config.config_data
          end
        end
      end

      nova_builder=job.job_group.smoke_test.nova_package_builder
      nova_deb_packager_url=nova_builder.deb_packager_url
      nova_rpm_packager_url=nova_builder.rpm_packager_url

      glance_builder=job.job_group.smoke_test.glance_package_builder
      glance_deb_packager_url=glance_builder.deb_packager_url
      glance_rpm_packager_url=glance_builder.rpm_packager_url

      keystone_builder=job.job_group.smoke_test.keystone_package_builder
      keystone_deb_packager_url=keystone_builder.deb_packager_url
      keystone_rpm_packager_url=keystone_builder.rpm_packager_url

      swift_builder=job.job_group.smoke_test.swift_package_builder
      swift_deb_packager_url=swift_builder.deb_packager_url
      swift_rpm_packager_url=swift_builder.rpm_packager_url

      cinder_builder=job.job_group.smoke_test.cinder_package_builder
      cinder_deb_packager_url=cinder_builder.deb_packager_url
      cinder_rpm_packager_url=cinder_builder.rpm_packager_url

      cookbook_url = ""
      if job.job_group.smoke_test.cookbook_url and not job.job_group.smoke_test.cookbook_url.blank? then
        cookbook_url = job.job_group.smoke_test.cookbook_url
      elsif not job.config_template.nil? then
        cookbook_url = job.config_template.cookbook_repo_url
      end

      config_template_description = ""
      if not job.config_template.nil? then
        config_template_description = job.config_template.description
      end

      args = ["bash",
        script_file,
        environment_file,
        nova_builder.url,
        nova_builder.branch || "",
        nova_builder.merge_trunk.to_s,
        nova_builder.revision_hash,
        nova_deb_packager_url,
        nova_rpm_packager_url,
        keystone_builder.url,
        keystone_builder.branch || "",
        keystone_builder.merge_trunk.to_s,
        keystone_builder.revision_hash,
        keystone_deb_packager_url,
        keystone_rpm_packager_url,
        glance_builder.url,
        glance_builder.branch || "",
        glance_builder.merge_trunk.to_s,
        glance_builder.revision_hash,
        glance_deb_packager_url,
        glance_rpm_packager_url,
        swift_builder.url,
        swift_builder.branch || "",
        swift_builder.merge_trunk.to_s,
        swift_builder.revision_hash,
        swift_deb_packager_url,
        swift_rpm_packager_url,
        cinder_builder.url,
        cinder_builder.branch || "",
        cinder_builder.merge_trunk.to_s,
        cinder_builder.revision_hash,
        cinder_deb_packager_url,
        cinder_rpm_packager_url,
        config_template_description,
        cookbook_url,
        node_configs_dir,
        server_group_json_file]

      job_timeout = ENV['JOB_TIMEOUT'] || '3600' #default to 1 hour
      status = nil
      job_pid = nil
      begin
        Timeout::timeout(job_timeout.to_i) do
          status = Open4::popen4(*args) do |pid, stdin, stdout, stderr|
            job_pid = pid
            stdin.close
            job.stdout=stdout.readlines.join.chomp
            job.stderr=stderr.readlines.join.chomp

            job.nova_revision=Job.parse_nova_revision(job.stdout)
            job.glance_revision=Job.parse_glance_revision(job.stdout)
            job.keystone_revision=Job.parse_keystone_revision(job.stdout)
            job.swift_revision=Job.parse_swift_revision(job.stdout)
            job.cinder_revision=Job.parse_cinder_revision(job.stdout)
            job.msg=Job.parse_last_message(job.stdout)
            job.save
          end
        end
      rescue Timeout::Error => te
        Process.kill("HUP", job_pid)
        job.update_attribute(:msg, "Timeout: " + te.message)
        job.update_attribute(:status, "Failed")
        return false
      end

      if status.exitstatus == 0
        job.update_attribute(:status, "Success")
        return true
      else
        job.update_attribute(:status, "Failed")
        return false
      end

    rescue Exception => e
      job.update_attribute(:msg, e.message)
      job.update_attribute(:status, "Failed")
      raise e
    ensure
      job.update_attribute(:finish_time, Time.now)
      FileUtils.rm_rf(base_dir)
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

  def self.parse_swift_revision(stdout)
    stdout.each_line do |line|
      if line =~ /^SWIFT_REVISION/ then
        return line.sub(/^SWIFT_REVISION=/, "").chomp
      end
    end
    return ""
  end

  def self.parse_cinder_revision(stdout)
    stdout.each_line do |line|
      if line =~ /^CINDER_REVISION/ then
        return line.sub(/^CINDER_REVISION=/, "").chomp
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
