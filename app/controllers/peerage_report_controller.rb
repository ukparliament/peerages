class PeerageReportController < ApplicationController
  
  def index
    @extinct_hereditary_peerages = Peerage.all.select( 'p.*, count(ph.id) as holder_count' ).joins( 'as p, peerage_holdings as ph' ).where( 'p.id = ph.peerage_id' ).where( 'p.last_number is not null' ).where( 'p.last_number > 1' ).group( 'p.id' ).order( 'p.last_number desc')
    
    @non_extinct_hereditary_peerages = Peerage.all.select( 'p.*, lp.patent_on as patent_on, count(ph.id) as holder_count' ).joins( 'as p, peerage_holdings as ph, letters_patents as lp' ).where( 'p.id = ph.peerage_id' ).where( 'p.last_number is null' ).where( 'p.peerage_type_id not in (1,5,6)' ).where( 'p.letters_patent_id = lp.id').group( 'p.id, lp.id' ).order( 'lp.patent_on' )
  end
end