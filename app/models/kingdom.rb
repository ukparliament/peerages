class Kingdom < ActiveRecord::Base
  
  has_many :peerages, -> { order( :alpha ) }
  
  def name_with_dates
    name_with_dates = self.name
    name_with_dates += ' ('
    name_with_dates += self.dates
    name_with_dates += ')'
    name_with_dates
  end
  
  def dates
    dates = ''
    dates += self.start_on.strftime( '%-d %B %Y') if self.start_on
    dates += ' - '
    dates += self.end_on.strftime( '%-d %B %Y') if self.end_on
    dates
  end
  
  def peerages_by_letter( letter )
    Peerage.all.where( 'letter_id = ?', letter.id ).where( 'kingdom_id = ?', self.id ).order( 'title' )
  end
  
  def ranks
    Rank.all.select( 'r.*').joins( 'as r, kingdom_ranks as kr' ).where( 'kr.kingdom_id = ?', self ).where( 'kr.rank_id = r.id' )
  end
  
  def peerages_by_rank( rank )
    Peerage.all.where( 'kingdom_id = ?', self ).where( 'rank_id =  ?', rank ).order( 'alpha' )
  end
end
