class PeerageHoldingController < ApplicationController
  
  def index
  end
  
  def show
    peerage_holding = params[:peerage_holding]
    @peerage_holding = PeerageHolding.find( peerage_holding )
  end
end
