class AboutController < ApplicationController

  def index
    respond_to do |format|
      format.html # about.html.erb
    end
  end

end
