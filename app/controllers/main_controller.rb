class MainController < ApplicationController

  before_filter :set_go
  def set_go
      if params[:go] and Util.valid_path?(params[:go]) then
          @go = params[:go]
      end
  end

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
