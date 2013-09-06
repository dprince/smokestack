class SmokeTestsController < ApplicationController

  before_filter :authorize, :except => [:index, :show]
  layout "default", :only => :index

  SMOKE_TESTS_OBJ_INCLUDES = [
    :package_builders,
    :config_modules
  ]

  # GET /smoke_tests
  # GET /smoke_tests.json
  # GET /smoke_tests.xml
  def index
    @smoke_tests = SmokeTest.find(:all, :include => SMOKE_TESTS_OBJ_INCLUDES, :order => [:project, :id])

    if params[:table_only] then
      render :partial => "table"
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json  { render :json => @smoke_tests } #formatted via as_json
        format.xml  { render :xml => @smoke_tests, :include => SMOKE_TESTS_OBJ_INCLUDES }
      end
    end
  end

  # GET /smoke_tests/1
  # GET /smoke_tests/1.json
  # GET /smoke_tests/1.xml
  def show
    @smoke_test = SmokeTest.find(params[:id], :include => SMOKE_TESTS_OBJ_INCLUDES)

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @smoke_test } #formated via as_json
      format.xml  { render :xml => @smoke_test, :include => SMOKE_TESTS_OBJ_INCLUDES }
    end
  end

  # GET /smoke_tests/new
  # GET /smoke_tests/new.xml
  def new
    @smoke_test = SmokeTest.new
    # package builders
    @smoke_test.build_nova_package_builder
    @smoke_test.nova_package_builder.merge_trunk = false
    @smoke_test.build_glance_package_builder
    @smoke_test.glance_package_builder.merge_trunk = false
    @smoke_test.build_keystone_package_builder
    @smoke_test.keystone_package_builder.merge_trunk = false
    @smoke_test.build_swift_package_builder
    @smoke_test.swift_package_builder.merge_trunk = false
    @smoke_test.build_cinder_package_builder
    @smoke_test.cinder_package_builder.merge_trunk = false
    @smoke_test.build_neutron_package_builder
    @smoke_test.neutron_package_builder.merge_trunk = false
    @smoke_test.build_ceilometer_package_builder
    @smoke_test.ceilometer_package_builder.merge_trunk = false
    @smoke_test.build_heat_package_builder
    @smoke_test.heat_package_builder.merge_trunk = false

    # config modules
    @smoke_test.build_nova_config_module
    @smoke_test.nova_config_module.merge_trunk = false
    @smoke_test.build_glance_config_module
    @smoke_test.glance_config_module.merge_trunk = false
    @smoke_test.build_keystone_config_module
    @smoke_test.keystone_config_module.merge_trunk = false
    @smoke_test.build_swift_config_module
    @smoke_test.swift_config_module.merge_trunk = false
    @smoke_test.build_cinder_config_module
    @smoke_test.cinder_config_module.merge_trunk = false
    @smoke_test.build_neutron_config_module
    @smoke_test.neutron_config_module.merge_trunk = false
    @smoke_test.build_ceilometer_config_module
    @smoke_test.ceilometer_config_module.merge_trunk = false
    @smoke_test.build_heat_config_module
    @smoke_test.heat_config_module.merge_trunk = false

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @smoke_test }
      format.xml  { render :xml => @smoke_test }
    end
  end

  # GET /smoke_tests/1/edit
  def edit
    @smoke_test = SmokeTest.find(params[:id])
  end

  # POST /smoke_tests
  # POST /smoke_tests.xml
  def create
    @smoke_test = SmokeTest.new(params[:smoke_test])

    respond_to do |format|
      if @smoke_test.save
        format.html { redirect_to(@smoke_test, :notice => 'Smoke test was successfully created.') }
        format.json  { render :json => @smoke_test, :status => :created, :location => @smoke_test }
        format.xml  { render :xml => @smoke_test, :status => :created, :location => @smoke_test }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @smoke_test.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @smoke_test.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /smoke_tests/1
  # PUT /smoke_tests/1.xml
  def update
    @smoke_test = SmokeTest.find(params[:id])

    if not params[:smoke_test][:test_suite_ids] and not params[:smoke_test][:config_templates]
      @smoke_test.config_templates.clear
      @smoke_test.test_suites.clear
    end
    respond_to do |format|
      if @smoke_test.update_attributes(params[:smoke_test])

        @smoke_test.test_suites.clear if @smoke_test.test_suites.size == 0
        format.html { redirect_to(@smoke_test, :notice => 'Smoke test was successfully updated.') }
        format.json  { render :json => @smoke_test, :status => :ok }
        format.xml  { render :xml => @smoke_test, :status => :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @smoke_test.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @smoke_test.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /smoke_tests/1
  # DELETE /smoke_tests/1.xml
  def destroy
    @smoke_test = SmokeTest.find(params[:id])
    @smoke_test.destroy

    respond_to do |format|
      format.html { redirect_to(smoke_tests_url) }
      format.json  { head :ok }
      format.xml  { head :ok }
    end
  end

  # POST /smoke_tests/1/run_jobs
  def run_jobs
    @smoke_test = SmokeTest.find(params[:id])

    job_group=JobGroup.create(
        :smoke_test => @smoke_test
    )

    respond_to do |format|
      format.html  { head :ok }
      format.json  { head :ok }
      format.xml  { head :ok }
    end

  end

end
