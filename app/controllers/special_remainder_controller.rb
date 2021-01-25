class SpecialRemainderController < ApplicationController
  
  def index
    @special_remainders = SpecialRemainder.all
  end
  
  def show
    special_remainder = params[:special_remainder]
    @special_remainder = SpecialRemainder.find( special_remainder )
  end
end
