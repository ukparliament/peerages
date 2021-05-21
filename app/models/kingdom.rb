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
  
  def reigns
    Reign.all.select( 'r.*, m.name as monarch_name' ).joins( 'as r, monarchs as m' ).where( 'r.monarch_id = m.id' ).where( 'kingdom_id = ?', self ).order( 'r.start_on desc' )
  end
  
  def peerages_by_letter( letter )
    Peerage.all.where( 'letter_id = ?', letter.id ).where( 'kingdom_id = ?', self.id ).order( 'title' )
  end
  
  def ranks
    Rank.all.select( 'r.*').joins( 'as r, kingdom_ranks as kr' ).where( 'kr.kingdom_id = ?', self ).where( 'kr.rank_id = r.id' ).where( 'is_peerage_rank is true' ).order( 'degree' )
  end
  
  def peerages_by_rank( rank )
    Peerage.all.where( 'kingdom_id = ?', self ).where( 'rank_id =  ?', rank ).order( 'alpha' )
  end
  
  def letters_patent
    LettersPatent.find_by_sql( "
      SELECT lp.id, lp.patent_on, lp.previous_rank, lp.previous_title, lp.administration_id,  lp.person_id, lpt.label AS letters_patent_time_inline, a.prime_minister AS prime_minister_inline, p.id AS person_id_inline, p.forenames AS person_forenames_inline, p.surname AS person_surname_inline, p.date_of_death AS person_date_of_death_inline
      FROM letters_patents lp
      LEFT JOIN letters_patent_times lpt
      ON lp.letters_patent_time_id = lpt.id
      LEFT JOIN administrations a ON lp.administration_id = a.id
      LEFT JOIN people p
      ON lp.person_id = p.id
      WHERE lp.kingdom_id = #{self.id}
      ORDER BY lp.patent_on, lp.ordinality_on_date;
    " )
  end
end
