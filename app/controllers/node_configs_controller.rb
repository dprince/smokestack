class NodeConfigsController < ApplicationController

  before_filter :require_admin
  before_filter :authorize

  # GET /node_configs
  # GET /node_configs.json
  # GET /node_configs.xml
  def index

    if request.format == Mime::XML
      limit=params[:limit].nil? ? 1000: params[:limit]
    else
      limit=params[:limit].nil? ? 50 : params[:limit]
    end

    config_template_id=params[:config_template_id]
    @config_template=ConfigTemplate.find(config_template_id)

    @node_configs = NodeConfig.find(:all, :conditions => ["config_template_id = ?", config_template_id], :order => "hostname DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @node_configs }
      format.json  { render :json => @node_configs }
    end
  end

  # GET /node_configs/1
  # GET /node_configs/1.json
  # GET /node_configs/1.xml
  def show
    @node_config = NodeConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @node_config }
      format.xml  { render :xml => @node_config }
    end
  end

  # POST /node_configs
  # POST /node_configs.json
  # POST /node_configs.xml
  def create
    @node_config = NodeConfig.new(params[:node_config])

    respond_to do |format|
      if @node_config.save
        format.xml  { render :xml => @node_config, :status => :created, :location => @node_config }
        format.any  { render :json => @node_config, :status => :created, :location => @node_config }
      else
        format.xml  { render :xml => @node_config.errors, :status => :unprocessable_entity }
        format.any  { render :json => @node_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /node_configs/1
  # PUT /node_configs/1.json
  # PUT /node_configs/1.xml
  def update
    @node_config = NodeConfig.find(params[:id])

    respond_to do |format|
      if @node_config.update_attributes(params[:node_config])
        format.html { redirect_to(@node_config, :notice => 'NodeConfig was successfully updated.') }
        format.json  { render :json => @node_config }
        format.xml  { render :xml => @node_config }
      else
        format.xml  { render :xml => @node_config.errors, :status => :unprocessable_entity }
        format.any  { render :json => @node_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /node_configs/1
  # DELETE /node_configs/1.json
  # DELETE /node_configs/1.xml
  def destroy
    @node_config = NodeConfig.destroy(params[:id])
    xml=@node_config.to_xml
    json=@node_config.to_json
    @node_config.destroy

    respond_to do |format|
      format.html { redirect_to(node_configs_url) }
      format.json  { render :json => json}
      format.xml  { render :xml => xml}
    end
  end

end
