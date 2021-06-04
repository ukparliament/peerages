class Person < ActiveRecord::Base
  
  belongs_to :letter
  belongs_to :gender
  has_many :peerage_holdings
  has_many :letters_patents, -> { order( :patent_on ) }
  
  def display_name
    display_name = ''
    display_name += self.forenames if self.forenames
    display_name += ' ' + self.surname if self.surname
    display_name
  end
  
  def list_display
    "#{self.surname.upcase} #{self.forenames} ( #{self.date_of_birth_display} - #{self.date_of_death_display} )"
  end
  
  def date_of_birth_display
    if self.date_of_birth
      date_of_birth_display = self.date_of_birth.strftime( '%-d %B %Y')
    else
      date_of_birth_display = 'Not known'
    end
    date_of_birth_display
  end
  
  def date_of_death_display
    date_of_death_display = ''
    if self.date_of_death
      date_of_death_display += self.date_of_death.strftime( '%-d %B %Y')
    end
    date_of_death_display
  end
  
  def peerages
    Peerage.all.select( 'p.*' ).joins( 'as p, peerage_holdings as ph, ranks as r' ).where( 'ph.peerage_id = p.id' ).where( 'ph.person_id = ?', self ).where( 'p.rank_id = r.id' ).order( 'r.degree' )
  end
  
  def has_external_identifiers?
    self.wikidata_id || self.mnis_id || self.rush_id
  end
  
  def wikidata_url
    "https://www.wikidata.org/wiki/#{self.wikidata_id}"
  end
  
  def mnis_url
    "https://members.parliament.uk/member/#{self.mnis_id}/contact"
  end
  
  def rush_url
    "https://membersafter1832.historyofparliamentonline.org/members/#{self.rush_id}"
  end
end
