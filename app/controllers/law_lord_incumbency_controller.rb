class LawLordIncumbencyController < ApplicationController
  
  def index
    @law_lord_incumbencies = LawLordIncumbency.all
  end
  
  def show
    law_lord_incumbency = params[:law_lord_incumbency]
    @law_lord_incumbency = LawLordIncumbency.find( law_lord_incumbency )
  end
end
