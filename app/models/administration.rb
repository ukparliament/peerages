class Administration < ActiveRecord::Base
  
  has_many :peerages, -> { order( :patent_on ) }
  
  def letters_patents
    @letters_patent = LettersPatent.find_by_sql( "SELECT lp.id, lp.patent_on, lp.previous_rank, lp.previous_title, lp.administration_id,  lp.person_id, lpt.label AS letters_patent_time_inline, a.prime_minister AS prime_minister_inline, p.id AS person_id_inline, p.forenames AS person_forenames_inline, p.surname AS person_surname_inline, p.date_of_death AS person_date_of_death_inline FROM letters_patents lp LEFT JOIN letters_patent_times lpt ON lp.letters_patent_time_id = lpt.id  LEFT JOIN administrations a ON lp.administration_id = a.id LEFT JOIN people p ON lp.person_id = p.id  WHERE lp.administration_id = #{self.id} ORDER BY lp.patent_on, lp.ordinality_on_date;" )
  end
  
  def prime_minister_ordinally
    prime_minister.gsub(/ \((.*)\)/) {|s| ', ' + s[2].to_i.ordinalize + ' administration'}
  end
  
  def prime_minister_reverse_ordinally
    if prime_minister.include?( '(' )
      pm = prime_minister.gsub(/ \((.*)\)/) {|s| ', ' + s[2].to_i.ordinalize}
    else
      pm = prime_minister
    end
    pm + ' administration'
  end
  
  def start_date_display
    if self.start_date
      start_date_display = self.start_date.strftime( '%-d %b %Y')
    else
      start_date_display = '-'
    end
    start_date_display
  end
  
  def end_date_display
    if self.end_date
      end_date_display = self.end_date.strftime( '%-d %b %Y')
    else
      end_date_display = '-'
    end
    end_date_display
  end
  
  def date_range
    date_range = self.start_date_display
    date_range += ' - '
    date_range += self.end_date_display if self.end_date
    date_range
  end
end


