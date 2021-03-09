class PeerageReportController < ApplicationController
  
  def index
    @peerages = Peerage.all.select( 'p.*, count(ph.id) as holder_count' ).joins( 'as p, peerage_holdings as ph' ).where( 'p.id = ph.peerage_id' ).where( 'p.last_number is not null' ).group( 'p.id' ).where( 'p.last_number > 1' ).order( 'p.last_number desc')
  end
end
