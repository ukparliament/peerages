class LettersPatent < ActiveRecord::Base
  
  # Legislation covering letters patent
  # https://www.legislation.gov.uk/uksi/1992/1730/made
  
  belongs_to :administration
  belongs_to :peerage_type
  belongs_to :announcement
  belongs_to :person
  belongs_to :letters_patent_time
  belongs_to :kingdom
  belongs_to :reign
  
  def peerages
    Peerage.all.select( 'p.*' ).joins( 'as p, ranks as r' ).where( 'letters_patent_id = ?', self.id).where( 'p.rank_id = r.id' ).order( 'r.degree' )
  end
  
  def previous_full_title
    if self.previous_rank
      previous_title = self.previous_rank + ' ' + self.previous_title
    else
      previous_title = '-'
    end
    previous_title
  end
  
  def prime_minister_reverse_ordinally
    pm = prime_minister_inline.gsub(/(.*)\((.*)\)/) {|s| $2.to_i.ordinalize + " " +  $1 + " administration"}
    if pm == prime_minister_inline
      pm = prime_minister_inline + ' administration'
    end
    pm
  end
  
  def previous_kingdom
    Kingdom.find( self.previous_kingdom_id ) if self.previous_kingdom_id
  end
end
