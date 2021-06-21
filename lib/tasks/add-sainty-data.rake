require 'csv'

task :add_sainty_data => :environment do
  puts "adding letters patent from sainty"
  CSV.foreach( 'db/data/sainty-letters-patent.csv' ) do |letters_patent_row|
    
    # Get the gender for the person.
    # This is outside of person creation because we may need it to get a previous gendered rank label.
    gender = Gender.all.where( 'label = ?', letters_patent_row[7].strip ).first
      
    # If this is a holding by a person already existing in the database ...
    if letters_patent_row[2]
    
      # ... we find the person.
      person = Person.find( letters_patent_row[2].strip)
    
    # Otherwise, if this is a new person
    else
    
      # Get the letter for the person.
      gender = Gender.all.where( 'label = ?', letters_patent_row[7].strip ).first
      if letters_patent_row[5]
        letter = Letter.all.where( 'letter = ?', letters_patent_row[5][0,1].upcase ).first
      end
    
      # Create a new person.
      person = Person.new
      person.forenames = letters_patent_row[4].strip if letters_patent_row[4]
      person.surname = letters_patent_row[5].strip if letters_patent_row[5]
      person.notes = letters_patent_row[8].strip if letters_patent_row[8]
      person.gender = gender
      person.letter = letter if letter
      person.save
    end
    
    # Find the kingdom
    kingdom = Kingdom.find_by_name( letters_patent_row[1].strip )
    
    # Find the reign.
    reign = Reign.all.where( 'kingdom_id = ?', kingdom ).where( 'start_on <= ?', letters_patent_row[9].strip ).where( 'end_on >= ? or end_on is null', letters_patent_row[9].strip ).first
    
    # Create the letters patent.
    letters_patent = LettersPatent.new
    letters_patent.patent_on = letters_patent_row[9].strip
    letters_patent.citations = letters_patent_row[10].strip
    letters_patent.person_prefix = letters_patent_row[3].strip if letters_patent_row[3]
    letters_patent.person_suffix = letters_patent_row[6].strip if letters_patent_row[6]
  
    # If there's a previous title ...
    if letters_patent_row[13]
    
      # ... if there's a previous Kingdom ...
      if letters_patent_row[14]
        previous_kingdom = Kingdom.find_by_name( letters_patent_row[14].strip )
        letters_patent.previous_kingdom_id = previous_kingdom.id
      end
    
      # Find the previous rank ...
      previous_rank = Rank.all.where( 'label = ?', letters_patent_row[11].strip ).first
      
      # ... and the previous rank label ...
      rank_label = RankLabel.all.where( 'gender_id = ?', gender.id ).where( 'rank_id = ?', previous_rank.id ).first
    
      # ... and store as previous_rank.
      letters_patent.previous_rank = rank_label.label
    
      letters_patent.previous_of_title = letters_patent_row[12]
      letters_patent.previous_title = letters_patent_row[13]
    end
    letters_patent.person = person
    letters_patent.kingdom = kingdom
    letters_patent.reign = reign if reign
    letters_patent.save
    
    # Loop through all the Sainty peerages ...
    CSV.foreach( 'db/data/sainty-peerages.csv' ) do |peerage_row|
      
      # ... and if this is a peerage associated with the Letters Patent ...
      if letters_patent_row[0] == peerage_row[5]
        
        # ... find the rank.
        rank = Rank.find_by_label( peerage_row[0].strip )
  
        #  ... find the letter.
        letter = Letter.all.where( 'letter = ?', peerage_row[1][0,1].upcase ).first
  
        # Find the peerage type.
        peerage_type = PeerageType.find_by_name( peerage_row[4] )
  
        # Create the peerage.
        peerage = Peerage.new
        peerage.of_title = false # NOTE: this data is not present in Sainty.
        peerage.title = peerage_row[1].strip
        peerage.notes = peerage_row[3].strip if peerage_row[11]
        peerage.rank = rank
        peerage.peerage_type = peerage_type
        peerage.special_remainder_id = peerage_row[2] if peerage_row[2]
        peerage.letters_patent = letters_patent
        peerage.letter = letter
        peerage.kingdom = kingdom
        peerage.save
        
        # Create the peerage holding.
        peerage_holding = PeerageHolding.new
        peerage_holding.ordinality = 1
        peerage_holding.start_on = letters_patent_row[9].strip
        peerage_holding.peerage = peerage
        peerage_holding.person = person
        peerage_holding.save
      end
    end
  end
end