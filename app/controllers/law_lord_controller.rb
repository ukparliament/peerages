class LawLordController < ApplicationController
  
  def index
    @law_lords = LawLord.all
  end
  
  def show
    law_lord = params[:law_lord]
    @law_lord = LawLord.find( law_lord )
  end
end
