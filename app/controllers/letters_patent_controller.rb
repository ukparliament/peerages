class LettersPatentController < ApplicationController
  
  def index
    @letters_patent = LettersPatent.find_by_sql( "SELECT lp.*, lpt.label AS letters_patent_time_inline, a.prime_minister AS prime_minister_inline, p.forenames AS person_forenames_inline, p.surname AS person_surname_inline, p.date_of_death AS person_date_of_death_inline FROM letters_patents lp LEFT JOIN letters_patent_times lpt ON lp.letters_patent_time_id = lpt.id  LEFT JOIN administrations a ON lp.administration_id = a.id LEFT JOIN people p ON lp.person_id = p.id ORDER BY lp.patent_on, lp.ordinality_on_date;" )
    respond_to do |format|
      format.html
      format.tsv
    end
  end
  
  def show
    letters_patent = params[:letters_patent]
    @letters_patent = LettersPatent.find( letters_patent )
  end
end
