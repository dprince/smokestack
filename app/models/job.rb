require 'erubis'
require 'open4'
require 'fileutils'
require 'timeout'

class Job < ActiveRecord::Base

  PUPPET_LIBVIRT = "Puppet Libvirt"
  PUPPET_CLOUDCUE = "Puppet Cloudcue"
  PUPPET_XEN = "Puppet Xen"
  JOB_TYPES = [PUPPET_LIBVIRT, PUPPET_CLOUDCUE, PUPPET_XEN]

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

  def self.run_job(job, template_name="puppet_runner.sh.erb", script_text=nil)
    ActiveRecord::Base.connection_handler.verify_active_connections!
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

      #write out config.yml
      File.open(File.join(node_configs_dir, 'config.yml'), 'w') do |f|
        #modules (puppet, etc)
        f.write("modules:\n")
        job.job_group.smoke_test.config_modules.each do |config_module|
          conf_module_type = config_module.type.chomp('ConfigModule').upcase
          f.write("    - name: #{conf_module_type.downcase}\n")
          f.write("      url: #{config_module.url}\n")
          f.write("      branch: #{config_module.branch}\n")
          f.write("      revision: #{config_module.revision_hash}\n")
          f.write("      merge_master: #{config_module.merge_trunk.to_s}\n")
          #FIXME: this is puppet specific
          f.write("      git_master: #{ENV["PUPPET_#{conf_module_type}_GIT_MASTER"]}\n")
        end
        #nodes info
        f.write("nodes:\n")
        job.config_template.node_configs.each do |node_config|
          f.write("    - name: #{node_config.hostname}\n")
          f.write("      manifest: #{node_config.hostname}\n")
        end
      end

      nova_builder=job.job_group.smoke_test.nova_package_builder
      nova_packager_url=nova_builder.packager_url
      nova_packager_branch=nova_builder.packager_branch

      glance_builder=job.job_group.smoke_test.glance_package_builder
      glance_packager_url=glance_builder.packager_url
      glance_packager_branch=glance_builder.packager_branch

      keystone_builder=job.job_group.smoke_test.keystone_package_builder
      keystone_packager_url=keystone_builder.packager_url
      keystone_packager_branch=keystone_builder.packager_branch

      swift_builder=job.job_group.smoke_test.swift_package_builder
      swift_packager_url=swift_builder.packager_url
      swift_packager_branch=swift_builder.packager_branch

      cinder_builder=job.job_group.smoke_test.cinder_package_builder
      cinder_packager_url=cinder_builder.packager_url
      cinder_packager_branch=cinder_builder.packager_branch

      neutron_builder=job.job_group.smoke_test.neutron_package_builder
      neutron_packager_url=neutron_builder.packager_url
      neutron_packager_branch=neutron_builder.packager_branch

      # config modules (puppet, etc)
      nova_config_module=job.job_group.smoke_test.nova_config_module
      glance_config_module=job.job_group.smoke_test.glance_config_module
      keystone_config_module=job.job_group.smoke_test.keystone_config_module
      swift_config_module=job.job_group.smoke_test.swift_config_module
      cinder_config_module=job.job_group.smoke_test.cinder_config_module
      neutron_config_module=job.job_group.smoke_test.neutron_config_module

      cookbook_url = ""
      if job.job_group.smoke_test.cookbook_url and not job.job_group.smoke_test
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
        nova_packager_url,
        nova_packager_branch,
        keystone_builder.url,
        keystone_builder.branch || "",
        keystone_builder.merge_trunk.to_s,
        keystone_builder.revision_hash,
        keystone_packager_url,
        keystone_packager_branch,
        glance_builder.url,
        glance_builder.branch || "",
        glance_builder.merge_trunk.to_s,
        glance_builder.revision_hash,
        glance_packager_url,
        glance_packager_branch,
        swift_builder.url,
        swift_builder.branch || "",
        swift_builder.merge_trunk.to_s,
        swift_builder.revision_hash,
        swift_packager_url,
        swift_packager_branch,
        cinder_builder.url,
        cinder_builder.branch || "",
        cinder_builder.merge_trunk.to_s,
        cinder_builder.revision_hash,
        cinder_packager_url,
        cinder_packager_branch,
        neutron_builder.url,
        neutron_builder.branch || "",
        neutron_builder.merge_trunk.to_s,
        neutron_builder.revision_hash,
        neutron_packager_url,
        neutron_packager_branch,
        config_template_description,
        cookbook_url,
        node_configs_dir,
        server_group_json_file]

      job_timeout = ENV['JOB_TIMEOUT'] || '3600' #default to 1 hour
      $status = nil
      $job_pid = nil
      $stdout_lines=""
      $stderr_lines=""

      def self.stream(stdout, stderr)
        begin
          loop do
            IO.select([stdout,stderr]).flatten.compact.each { |io|
              if io.fileno == stdout.fileno
                $stdout_lines += io.readpartial(1024)
              end
              if io.fileno == stderr.fileno
                $stderr_lines += io.readpartial(1024)
              end
            }
          end
        rescue Errno::EAGAIN
          retry
        rescue EOFError
        end
      end

      begin
        Timeout::timeout(job_timeout.to_i) do
            $job_pid, stdin, stdout, stderr = Open4::popen4(*args)
            stdin.close
            stream(stdout, stderr)
            Process.wait($job_pid)
            $status = $?
        end
        ActiveRecord::Base.connection_handler.verify_active_connections!
        job.stdout=$stdout_lines.chomp
        job.stderr=$stderr_lines.chomp
        job.msg=Job.parse_last_message(job.stdout)
        Job.parse_revisions(job)
        job.save

      rescue Timeout::Error => te
        Process.kill("HUP", $job_pid)
        ActiveRecord::Base.connection_handler.verify_active_connections!
        job.stdout=$stdout_lines.chomp
        job.stderr=$stderr_lines.chomp
        Job.parse_revisions(job)
        job.msg="Timeout: " + te.message
        job.status="Failed"
        job.save
        return false
      end

      if $status.exitstatus == 0
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

  def self.parse_revisions(job)

    revisions = {}
    regex = Regexp.new("^(.*_REVISION)=(.*)$")
    job.stdout.each_line do |line|
      if line =~ regex then
        revisions.store($1, $2)
      end
    end

    # core project revisions
    job.nova_revision=revisions['NOVA_REVISION']
    job.glance_revision=revisions['GLANCE_REVISION']
    job.keystone_revision=revisions['KEYSTONE_REVISION']
    job.swift_revision=revisions['SWIFT_REVISION']
    job.cinder_revision=revisions['CINDER_REVISION']
    job.neutron_revision=revisions['NEUTRON_REVISION']

    # config module revisions (puppet, etc)
    job.nova_conf_module_revision=revisions['NOVA_CONFIG_MODULE_REVISION']
    job.keystone_conf_module_revision=revisions['KEYSTONE_CONFIG_MODULE_REVISION']
    job.glance_conf_module_revision=revisions['GLANCE_CONFIG_MODULE_REVISION']
    job.swift_conf_module_revision=revisions['SWIFT_CONFIG_MODULE_REVISION']
    job.cinder_conf_module_revision=revisions['CINDER_CONFIG_MODULE_REVISION']
    job.neutron_conf_module_revision=revisions['NEUTRON_CONFIG_MODULE_REVISION']
    job
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

  def as_json(options={})
    hash = {self.type.underscore => super}
  end

end
