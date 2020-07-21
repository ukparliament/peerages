class PersonAtozController < ApplicationController
  
  def index
    @letters = Letter.all
  end
  
  def show
    @letters = Letter.all
    letter = params[:letter]
    @letter = Letter.find( letter )
  end
end
