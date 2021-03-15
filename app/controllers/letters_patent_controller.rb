class LettersPatentController < ApplicationController
  
  def index
    @letters_patent = LettersPatent.all.joins( 'as lp, letters_patent_times as lpt, administrations as a, people as p' ).select( 'lp.*, lpt.label as letters_patent_time_inline, a.prime_minister as prime_minister_inline, p.forenames as person_forenames_inline, p.surname as person_surname_inline, p.date_of_death as person_date_of_death_inline' ).where( 'lp.letters_patent_time_id = lpt.id and lp.administration_id = a.id and lp.person_id = p.id' ).order( 'lp.patent_on' ).order( 'lp.ordinality_on_date' )
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
