class LettersPatent < ActiveRecord::Base
  
  # Legislation covering letters patent
  # https://www.legislation.gov.uk/uksi/1992/1730/made
  
  belongs_to :administration
  belongs_to :peerage_type
  belongs_to :announcement
  belongs_to :person
  
  def peerages
    Peerage.all.select( 'p.*' ).joins( 'as p, ranks as r' ).where( 'letters_patent_id = ?', self.id).where( 'p.rank_id = r.id' ).order( 'r.degree' )
  end
end
