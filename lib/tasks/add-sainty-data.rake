require 'csv'

task :add_sainty_data => :environment do
  puts "adding non-uk peerages from sainty"
  CSV.foreach( 'db/data/sainty.csv' ) do |row|
    
    # Find the kingdom
    kingdom = Kingdom.find_by_name( row[0].strip )
    
    # If this is a holding by a person already existing in the database ...
    if row[1]
      
      # ... we find the person.
      person = Person.find( row[1].strip)
      
    # Otherwise, if this is a new person
    else
      
      # Get the gender and letter for the person.
      gender = Gender.all.where( 'label = ?', row[6] ).first
      if row[4]
        letter = Letter.all.where( 'letter = ?', row[4][0,1].upcase ).first
      end
      
      # Create a new person.
      person = Person.new
      person.prefix = row[2].strip if row[2]
      person.forenames = row[3].strip if row[3]
      person.surname = row[4].strip if row[4]
      person.suffix = row[5].strip if row[5]
      person.notes = row[7].strip if row[7]
      person.gender = gender
      person.letter = letter if letter
      # This can't be null
      if row[6] == 'Male'
        person.gender_char = 'm'
      else
        person.gender_char = 'f'
      end
      person.save
    end
    
    # Find the reign.
    reign = Reign.all.where( 'kingdom_id = ?', kingdom ).where( 'start_on <= ?', row[13].strip ).where( 'end_on >= ? or end_on is null', row[13].strip ).first
    
    # Create the letters patent.
    letters_patent = LettersPatent.new
    letters_patent.patent_on = row[13].strip
    letters_patent.citations = row[14].strip
    
    # If there's a previous title ...
    if row[17]
      
      # ... if there's a previous Kingdom ...
      if row[18]
        previous_kingdom = Kingdom.find_by_name( row[18].strip )
        letters_patent.previous_kingdom_id = previous_kingdom.id
      end
      
      # Find the previous rank ...
      previous_rank = Rank.all.where( 'label = ?', row[15].strip ).first
      
      # ... and the previous rank label ...
      rank_label = RankLabel.all.where( 'gender_id = ?', gender.id ).where( 'rank_id = ?', previous_rank.id ).first
      
      # ... and store as previous_rank.
      letters_patent.previous_rank = rank_label.label
      
      letters_patent.previous_of_title = row[16]
      letters_patent.previous_title = row[17]
    end
    letters_patent.person = person
    letters_patent.kingdom = kingdom
    letters_patent.reign = reign if reign
    letters_patent.save
    
    # Find the rank.
    rank = Rank.find_by_label( row[8].strip )
    
    # Find the letter.
    letter = Letter.all.where( 'letter = ?', row[9][0,1].upcase ).first
    
    # Find the peerage type.
    peerage_type = PeerageType.find_by_name( row[12] )
    
    # Create the peerage.
    peerage = Peerage.new
    peerage.of_title = false # NOTE: this data is not present in Sainty.
    peerage.title = row[9].strip
    peerage.notes = row[11].strip if row[11]
    peerage.alpha = row[9][0, 10].upcase
    peerage.rank = rank
    peerage.peerage_type = peerage_type
    peerage.special_remainder_id = row[10] if row[10]
    peerage.letters_patent = letters_patent
    peerage.letter = letter
    peerage.kingdom = kingdom
    peerage.save
    
    # Create the peerage holding.
    peerage_holding = PeerageHolding.new
    peerage_holding.ordinality = 1
    peerage_holding.start_on = row[13].strip
    peerage_holding.peerage = peerage
    peerage_holding.person = person
    peerage_holding.save
  end
end


