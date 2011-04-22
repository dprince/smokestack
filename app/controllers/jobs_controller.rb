class JobsController < ApplicationController
  # GET /jobs
  # GET /jobs.xml
  def index
    @jobs = Job.find(:all, :select => "id, status, revision, msg, smoke_test_id, created_at, updated_at", :include => [:smoke_test])

    if params[:table_only] then
      render :partial => "table"
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
      format.json  { render :json => @job }
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    @job = Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @job }
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.save
        format.html { redirect_to(@job, :notice => 'Job was successfully created.') }
        format.json  { render :json => @job, :status => :created, :location => @job }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @job.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to(@job, :notice => 'Job was successfully updated.') }
        format.json  { head :ok }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
end
