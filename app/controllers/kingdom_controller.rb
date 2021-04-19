class KingdomController < ApplicationController
  
  def index
    @kingdoms = Kingdom.all.order( 'end_on, start_on')
  end
  
  def show
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
  end
end
