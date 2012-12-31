class AboutController < ApplicationController

  layout "default"

  def index
    respond_to do |format|
      format.html # about.html.erb
    end
  end

end
