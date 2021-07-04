class LettersPatentController < ApplicationController
  
  def index
    @letters_patent = LettersPatent.find_by_sql( 
      "
        SELECT 
          lp.*,
          
          kingdom_join.kingdom_id AS kingdom_id_inline,
          kingdom_join.kingdom_name AS kingdom_name_inline,
          
          reign_join.reign_title AS reign_title_inline,
          reign_join.reign_id AS reign_id_inline,
          
          letters_patent_time_join.letters_patent_time_label AS letters_patent_time_inline,
          
          announcement_join.administration_id AS administration_id_inline,
          announcement_join.prime_minister AS prime_minister_inline,
          
          peerage_join.peerage_id AS peerage_id_inline,
          peerage_join.peerage_of_title AS peerage_of_title_inline,
          peerage_join.peerage_title AS peerage_title_inline,
          peerage_join.peerage_extinct_on AS peerage_extinct_on_inline,
          peerage_join.peerage_last_number AS peerage_last_number_inline,
          peerage_join.rank_label AS rank_label_inline,
          peerage_join.peerage_type_id_inline AS peerage_type_id_inline,
          peerage_join.peerage_type_name_inline AS peerage_type_name_inline,
          
          person_join.person_forenames AS person_forenames_inline,
          person_join.person_surname AS person_surname_inline,
          person_join.person_date_of_death AS person_date_of_death_inline
          
        FROM letters_patents lp
        
        JOIN (
          SELECT 
            k.id as kingdom_id,
            k.name as kingdom_name
          FROM kingdoms k
        ) kingdom_join
        ON kingdom_join.kingdom_id = lp.kingdom_id
        
        LEFT JOIN (
          SELECT 
            r.title as reign_title,
            r.id as reign_id
          FROM reigns r
        ) reign_join
        ON reign_join.reign_id = lp.reign_id
          
        LEFT JOIN (
          SELECT
            lpt.id AS patent_time_id,
            lpt.label AS letters_patent_time_label
          FROM letters_patent_times lpt
        ) letters_patent_time_join
        ON letters_patent_time_join.patent_time_id = lp.letters_patent_time_id
        
        LEFT JOIN (
          SELECT
            an.id AS announcement_id,
            ad.id AS administration_id,
            ad.prime_minister AS prime_minister
          FROM announcements an, administrations ad
          WHERE an.administration_id = ad.id
        ) announcement_join
        ON announcement_join.announcement_id = lp.announcement_id
        
        JOIN (
          SELECT
            DISTINCT ON (p.letters_patent_id) degree,
            p.letters_patent_id AS letters_patent_id,
            p.id AS peerage_id,
            p.of_title AS peerage_of_title,
            p.extinct_on AS peerage_extinct_on,
            p.last_number AS peerage_last_number,
            p.title AS peerage_title,
            r.label AS rank_label,
            pt.id AS peerage_type_id_inline,
            pt.name AS peerage_type_name_inline
          FROM peerages p, ranks r, peerage_types pt
          WHERE p.rank_id = r.id
          AND p.peerage_type_id = pt.id
          ORDER BY p.letters_patent_id, r.degree
        ) peerage_join
        ON peerage_join.letters_patent_id = lp.id
        
        JOIN (
          SELECT
            p.id AS person_id,
            p.forenames as person_forenames,
            p.surname as person_surname,
            p.date_of_death as person_date_of_death
            from people p
        ) person_join
        ON person_join.person_id = lp.person_id
        
        ORDER BY lp.patent_on, lp.ordinality_on_date;
      "
    )
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
