class KingdomReignController < ApplicationController
  
  def index
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
    @reigns = @kingdom.reigns
  end
end
