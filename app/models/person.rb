class Person < ActiveRecord::Base
  
  belongs_to :letter
  belongs_to :gender
  has_many :peerage_holdings
  has_many :letters_patents, -> { order( :patent_on ) }
  
  def display_name
    "#{self.forenames} #{self.surname}"
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
    #Peerage.all.select.( 'p.*' ).joins( 'as p, peerage_holdings as ph' ).where( 'ph.peerage_id = p.id' )
    #Peerage.all.select.( 'p.*' ).joins( 'as p' )
    Peerage.all.select( 'p.*' ).joins( 'as p, peerage_holdings as ph, ranks as r' ).where( 'ph.peerage_id = p.id' ).where( 'ph.person_id = ?', self ).where( 'p.rank_id = r.id' ).order( 'r.degree' )
  end
end
