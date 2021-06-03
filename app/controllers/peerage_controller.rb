class PeerageController < ApplicationController
  
  def index
    @peerages = Peerage.all.order( 'title' )
  end
  
  def show
    peerage = params[:peerage]
    @peerage = Peerage.find( peerage )
  end
end
