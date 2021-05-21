class KingdomController < ApplicationController
  
  def index
    @kingdoms = Kingdom.all.order( 'end_on desc, start_on desc' )
  end
  
  def show
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
  end
end
