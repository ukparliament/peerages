require 'csv'

task :add_subsequent_holders => :environment do
  puts "adding subsequent peerage holders"
  CSV.foreach( 'db/data/subsequent-holders.csv' ) do |row|
    
    # If this is a holding by a person already existing in the database ...
    if row[4]
      
      # ... we find the person.
      person = Person.find( row[4].strip)
      
    # Otherwise, if this is a new person
    else  
    
      # Get the gender and letter for the person.
      gender = Gender.all.where( 'label = ?', row[9] ).first
      letter = Letter.all.where( 'letter = ?', row[6][0,1].upcase ).first
    
      # Create a new person.
      person = Person.new
      person.forenames = row[5].strip
      person.surname = row[6].strip
      person.date_of_birth = row[7]
      person.date_of_death = row[8] if row[8]
      person.gender = gender
      person.letter = letter
      # This can't be null
      if row[9] = 'Male'
        person.gender_char = 'm'
      else
        person.gender_char = 'f'
      end
      person.save
    end
    
    # Get the peerage of the holding.
    peerage = Peerage.find( row[ 0] )
    
    # Create a new holding
    peerage_holding = PeerageHolding.new
    peerage_holding.ordinality = row[3]
    peerage_holding.start_on = row[1]
    peerage_holding.end_on = row[2]
    peerage_holding.person = person
    peerage_holding.peerage = peerage
    peerage_holding.notes = row[10].strip if row[10]
    peerage_holding.save
  end
end