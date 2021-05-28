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
  
  def peerage_full_title
    peerage_full_title = ''
    peerage_full_title += 'of ' if self.peerage_of_title_inline
    peerage_full_title += self.peerage_title_inline if self.peerage_title_inline
    peerage_full_title += ' (' + self.rank_label_inline + ')' if self.rank_label_inline
    peerage_full_title
  end
  
  def person_full_name
    person_full_name = ''
    person_full_name += self.person_prefix_inline + ' ' if self.person_prefix_inline
    person_full_name += self.person_forenames_inline if self.person_forenames_inline
    person_full_name += ' ' + self.person_surname_inline if self.person_surname_inline
    person_full_name += ', ' + self.person_suffix_inline + ' ' if self.person_suffix_inline
    person_full_name
  end
  
  def peerage_extinction_label
    peerage_extinction_label = ''
    if self.peerage_extinct_on_inline
      peerage_extinction_label = self.peerage_extinct_on_inline.strftime( '%-d %B %Y')
      peerage_extinction_label += ' (with the ' + self.peerage_last_number_inline.ordinalize + ' holder)'
    else
      peerage_extinction_label = '-'
    end
    peerage_extinction_label
  end
end
