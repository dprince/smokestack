class JobsController < ApplicationController

  before_filter :authorize, :except => [:index, :show]
  layout "default", :only => :index

  # GET /jobs
  # GET /jobs.xml
  def index

    limit=params[:limit].nil? ? 50 : params[:limit]

    @jobs = Job.find(:all, :select => "id, status, type, job_group_id, nova_revision, glance_revision, keystone_revision, swift_revision, cinder_revision, neutron_revision, nova_conf_module_revision, glance_conf_module_revision, keystone_conf_module_revision, swift_conf_module_revision, cinder_conf_module_revision, neutron_conf_module_revision, msg, config_template_id, created_at, updated_at, start_time, finish_time, approved_by", :include => [:config_template,:approved_by_user, {:job_group => :smoke_test}], :order => "id DESC", :limit => limit)

    if params[:table_only] then
      render(:partial => "table", :locals => {:show_updated_at => false, :show_description => true})
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json  { render :json => @jobs }
        format.xml  { render :xml => @jobs }
      end
    end

  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @job, :include => :job_group }
      format.xml  { render :xml => @job, :include => :job_group }
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find(params[:id])
    approved_by = nil
    if params[:job] and params[:job][:approved] then
      approved_by = session[:user_id]
    end

    respond_to do |format|
      # We only allow the approval to be updated on jobs
      if @job.update_attribute(:approved_by, approved_by)
        format.html { redirect_to("/jobs/#{@job.id}", :notice => 'Job was successfully created.') }
        format.json  { render :json => @job, :status => :ok }
        format.xml  { render :xml => @job, :status => :ok }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @job.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end

  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    json=@job.to_json
    xml=@job.to_xml
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.json  { render :json => json }
      format.xml  { render :xml => xml }
    end
  end

  # POST /jobs/1/clone (used to rerun a job)
  def clone

    orig_job = Job.find(params[:id])

    @job = Kernel.const_get(orig_job.type).new(
      :job_group => orig_job.job_group,
      :config_template => orig_job.config_template,
    )

    respond_to do |format|
      if @job.save
        format.html { redirect_to(@job, :notice => 'Job was successfully cloned.') }
        format.json  { render :json => @job, :status => :created, :location => "jobs/#{@job.id}" }
        format.xml  { render :xml => @job, :status => :created, :location => "jobs/#{@job.id}" }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @job.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end

    end

  end

end
