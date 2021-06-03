class KingdomLettersPatentController < ApplicationController
  
  def index
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
    @letters_patent = @kingdom.letters_patent

    respond_to do |format|
      format.html
      format.tsv {
        render :template => 'letters_patent/index'
      }
    end
  end
end
