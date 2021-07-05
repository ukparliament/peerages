class Monarch < ActiveRecord::Base
  
  def reigns
    Reign.all.select( 'r.*' ).joins( 'as r, reigning_monarchs as rm, kingdoms as k' ).where( 'r.id = rm.reign_id' ).where( 'rm.monarch_id = ?', self ).where( 'r.kingdom_id = k.id' ).order( 'r.start_on' )
  end
  
  def date_range
    date_range = self.date_of_birth.strftime( '%-d %B %Y') + ' - '
    if self.date_of_death
      date_range += self.date_of_death.strftime( '%-d %B %Y')
    end
    date_range
  end
  
  def wikidata_url
    "https://www.wikidata.org/wiki/#{self.wikidata_id}"
  end
end
