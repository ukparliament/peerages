class PeerageTypeController < ApplicationController
  
  def index
    @peerage_types = PeerageType.all.order( 'name' )
  end
  
  def show
    peerage_type = params[:peerage_type]
    @peerage_type = PeerageType.find ( peerage_type )
  end
  
  def peerages
    peerage_type = params[:peerage_type]
    @peerage_type = PeerageType.find ( peerage_type )
  end
end
