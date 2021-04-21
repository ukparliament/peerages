class KingdomPeerageController < ApplicationController
  
  def index
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
  end
end
