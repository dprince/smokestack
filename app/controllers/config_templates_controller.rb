class ConfigTemplatesController < ApplicationController

  before_filter :require_admin
  before_filter :authorize
  layout "default", :only => :index

  # GET /config_templates
  # GET /config_templates.xml
  def index
    @config_templates = ConfigTemplate.all

    if params[:table_only] then
      render :partial => "table"
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json  { render :json => @config_templates }
        format.xml  { render :xml => @config_templates }
      end
    end
  end

  # GET /config_templates/1
  # GET /config_templates/1.xml
  def show
    @config_template = ConfigTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @config_template }
      format.xml  { render :xml => @config_template }
    end
  end

  # GET /config_templates/new
  # GET /config_templates/new.xml
  def new
    @config_template = ConfigTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @config_template }
      format.xml  { render :xml => @config_template }
    end
  end

  # GET /config_templates/1/edit
  def edit
    @config_template = ConfigTemplate.find(params[:id])
  end

  # POST /config_templates
  # POST /config_templates.xml
  def create
    @config_template = ConfigTemplate.new(params[:config_template])

    respond_to do |format|
      if @config_template.save
        format.html { redirect_to(@config_template, :notice => 'ConfigTemplate was successfully created.') }
        format.json  { render :json => @config_template, :status => :created, :location => @config_template }
        format.xml  { render :xml => @config_template, :status => :created, :location => @config_template }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @config_template.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @config_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /config_templates/1
  # PUT /config_templates/1.xml
  def update
    @config_template = ConfigTemplate.find(params[:id])

    respond_to do |format|
      if @config_template.update_attributes(params[:config_template])
        format.html { redirect_to(@config_template, :notice => 'ConfigTemplate was successfully updated.') }
        format.json  { render :json => @config_template, :status => :ok }
        format.xml  { render :xml => @config_template, :status => :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @config_template.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @config_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /config_templates/1
  # DELETE /config_templates/1.xml
  def destroy
    @config_template = ConfigTemplate.find(params[:id])
    json=@config_template.to_json
    xml=@config_template.to_xml

    @config_template.destroy

    respond_to do |format|
      format.html { redirect_to(config_templates_url) }
      format.json  { render :json => json }
      format.xml  { render :xml => xml }
    end

  end

  # POST /config_templates/1/clone
  def clone

    orig = ConfigTemplate.find(params[:id])

    @config_template = ConfigTemplate.new(
        :job_type => orig.job_type,
        :name => orig.name + " Clone",
        :description => orig.description + " Clone",
        :cookbook_repo_url => orig.cookbook_repo_url,
        :environment => orig.environment,
        :server_group_json => orig.server_group_json
    )

    respond_to do |format|
      if @config_template.save

        orig.node_configs.each do |node_config|
            NodeConfig.create(
                :config_template_id => @config_template.id,
                :hostname => node_config.hostname,
                :config_data => node_config.config_data
            )
        end
        format.html { redirect_to(@config_template, :notice => 'ConfigTemplate was successfully cloned.') }
        format.json  { render :json => @config_template, :status => :created, :location => @config_template }
        format.xml  { render :xml => @config_template, :status => :created, :location => @config_template }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @config_template.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @config_template.errors, :status => :unprocessable_entity }
      end

    end

  end

end
