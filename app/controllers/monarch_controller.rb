class MonarchController < ApplicationController
  
  def index
    @monarchs = Monarch.all
  end
  
  def show
    monarch = params[:monarch]
    @monarch = Monarch.find( monarch )
  end
end
