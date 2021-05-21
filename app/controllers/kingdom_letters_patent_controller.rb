class KingdomLettersPatentController < ApplicationController
  
  def index
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
    @letters_patents = @kingdom.letters_patent
  end
end
