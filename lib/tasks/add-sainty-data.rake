require 'csv'

task :add_sainty_data => :environment do
  puts "adding non-uk peerages from sainty"
  CSV.foreach( 'db/data/sainty.csv' ) do |row|
    
    # Find the kingdom
    kingdom = Kingdom.find_by_name( "Kingdom of #{row[0].strip}" )
    
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
      
      person = Person.new
      person.prefix = row[2].strip if row[2]
      person.forenames = row[3].strip if row[3]
      person.surname = row[4].strip if row[4]
      person.suffix = row[5].strip if row[5]
      person.notes = row[7].strip if row[7]
      person.gender = gender
      person.letter = letter if letter
      # This can't be null
      if row[9] = 'Male'
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
    # If there's a previous rank ...
    if row[15]
      letters_patent.previous_rank = row[15].strip
    end
    # If there's a previous title ...
    if row[16]
      if row[17] == 'TRUE'
        letters_patent.previous_title = 'of ' + row[16].strip
      elsif row[17] == 'FALSE'
        letters_patent.previous_title = row[16].strip
      end
    end
    letters_patent.citations = row[14].strip
    letters_patent.person = person
    letters_patent.kingdom = kingdom
    letters_patent.reign = reign if reign
    letters_patent.save
    
    # Find the rank.
    rank = Rank.find_by_label( row[8].strip )
    
    # Find the letter.
    #letter = Letter.all.where( 'letter = ?', row[9][0,1].upcase ).first
    
    # Find the peerage type.
    peerage_type = PeerageType.find_by_name( row[12] )
    
    # Create the peerage.
    peerage = Peerage.new
    peerage.of_title = false # NOTE: this data is not present in Sainty.
    puts row[9] #wtf
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
  end
end