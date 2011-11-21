class MainController < ApplicationController

  before_filter :set_go
  def set_go
      if params[:go] and Util.valid_path?(params[:go]) then
          @go = params[:go]
      end
  end

  # GET /main
  def main
    respond_to do |format|
      format.html # main.html.erb
    end
  end

end
