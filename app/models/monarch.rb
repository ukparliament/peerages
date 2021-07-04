class Monarch < ActiveRecord::Base
  
  def reigns
    Reign.all.select( 'r.*' ).joins( 'as r, reigning_monarchs as rm, kingdoms as k' ).where( 'r.id = rm.reign_id' ).where( 'rm.monarch_id = ?', self ).where( 'r.kingdom_id = k.id' ).order( 'r.start_on' )
  end
end
