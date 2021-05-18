class Monarch < ActiveRecord::Base
  
  def reigns
    Reign.all.select( 'r.*, k.name as kingdom_name' ).joins( 'as r, kingdoms as k' ).where( 'r.kingdom_id = k.id' ).where( 'r.monarch_id = ?', self ).order( 'r.start_on' )
  end
end
