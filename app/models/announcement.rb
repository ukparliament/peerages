class Announcement < ActiveRecord::Base
  
  belongs_to :announcement_type
  has_many :peerages, -> { order( :patent_on ) }
  
  def letters_patents
    @letters_patent = LettersPatent.find_by_sql( "SELECT lp.id, lp.patent_on, lp.previous_rank, lp.previous_title, lp.administration_id,  lp.person_id, lpt.label AS letters_patent_time_inline, a.prime_minister AS prime_minister_inline, p.id AS person_id_inline, p.forenames AS person_forenames_inline, p.surname AS person_surname_inline, p.date_of_death AS person_date_of_death_inline FROM letters_patents lp LEFT JOIN letters_patent_times lpt ON lp.letters_patent_time_id = lpt.id  LEFT JOIN administrations a ON lp.administration_id = a.id LEFT JOIN people p ON lp.person_id = p.id  WHERE lp.announcement_id = #{self.id} ORDER BY lp.patent_on, lp.ordinality_on_date;" )
  end
end
