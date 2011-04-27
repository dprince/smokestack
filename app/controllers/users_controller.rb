class UsersController < ApplicationController

  before_filter :require_admin, :except => [:password, :update]
  before_filter :authorize
  before_filter :require_admin_or_self, :only => [:password, :update]

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    if params[:table_only] then
      render :partial => "table"
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json  { render :json => @users }
        format.xml  { render :xml => @users }
      end
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @user }
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @user }
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.json  { render :json => @user, :status => :created, :location => @user }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.json  { head :ok }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    json=@user.to_json
    xml=@user.to_xml

    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.json  { render :json => json }
      format.xml  { render :xml => xml }
    end
  end

  # GET /users/1/password
  def password
    @user = User.find(params[:id])
  end

  private
  def require_admin_or_self
    return true if is_admin
    return true if session[:user_id] and params[:id] and session[:user_id] == params[:id].to_i
    render :text => "Attempt to view an unauthorized record.", :status => "401"
    return false
  end

end
