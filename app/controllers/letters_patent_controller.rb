class LettersPatentController < ApplicationController
  
  def index
    @letters_patent = LettersPatent.all.order( 'patent_on' )
    respond_to do |format|
      format.html
      format.tsv
    end
  end
  
  def show
    letters_patent = params[:letters_patent]
    @letters_patent = LettersPatent.find( letters_patent )
  end
end
