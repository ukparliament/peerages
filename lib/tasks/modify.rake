require 'csv'

task :modify => [
  :populate_kingdoms,
  :collapse_title_of_into_peerage,
  :normalise_people,
  :populate_letters,
  :normalise_letters,
  :normalise_genders,
  :populate_rank_labels,
  :collapse_ranks_across_genders,
  :normalise_jurisdictions_from_law_lord_incumbencies,
  :normalise_special_remainders_from_peerages,
  :normalise_special_remainders_from_subsidiary_titles,
  :normalise_letters_patent,
  :link_announcements_to_administration,
  :port_subsidiary_titles_to_peerages,
  :link_letter_patent_to_peerages,
  :link_peerage_to_letters,
  :add_labels_to_ranks,
  :extract_letters_patent_times,
  :downcase_letter_patent_at_time,
  :set_letters_patent_ordinality_in_day,
  :deprecate_princes,
  :link_peerages_to_kingdom,
  :link_letters_patent_to_kingdom,
  :link_ranks_to_kingdoms,
  :add_lordships,
  :normalise_previous_kingdoms,
  :normalise_previous_of_title,
  :remove_dots_from_previous_ranks,
  :expand_previous_titles,
  :remove_incorrect_special_remainder] do
end

task :populate_kingdoms => :environment do
  puts "populating kingdoms"
  CSV.foreach( 'db/data/kingdoms.csv' ) do |row|
    kingdom = Kingdom.new
    kingdom.name = row[0].strip
    kingdom.start_on = row[1]
    kingdom.end_on = row[2]
    kingdom.save
  end
end
task :collapse_title_of_into_peerage => :environment do
  puts "collapsing the of of the rank back to the peerages"
  ranks = Rank.all
  ranks.each do |rank|
    # If the last three letters are ' of'
    if rank.name[rank.name.length - 3, 3] == ' of'
      
      # ...find the same rank with no of
      ofless_rank = Rank.all.where( 'name = ?', rank.name[0, rank.name.length - 3] ).first
      if ofless_rank
        
        # ...loop through all the peerages with the rank with an of...
        
        rank.peerages.each do |peerage|
          # say yeah, this got of
          peerage.of_title = true
          # assign to ofless rank
          peerage.rank = ofless_rank
          peerage.save
        end
        
        # same again for subsidiary titles...
        
        rank.subsidiary_titles.each do |subsidiary_title|
          # say yeah, this got of
          subsidiary_title.of_title = true
          # assign to ofless rank
          subsidiary_title.rank = ofless_rank
          subsidiary_title.save
        end
        
        # get rid the rank with d of
        rank.destroy
      
      # ...else if there's no non-of equivalent
      else
        
        # ...loop through all the peerages with the rank with an of...
        
        rank.peerages.each do |peerage|
          # say yeah, this got of
          peerage.of_title = true
          peerage.save
        end
        
        # same again for subsidiary titles...
        
        rank.subsidiary_titles.each do |subsidiary_title|
          # say yeah, this got of
          subsidiary_title.of_title = true
          subsidiary_title.save
        end
        
        # remove the of from the rank name
        rank.name = rank.name[0, rank.name.length - 3]
        rank.save
      end
    end
  end
end
task :normalise_people => :environment do
  puts "normalising people from the peerage table"
  peerages = Peerage.all
  peerages.each do |peerage|
    person = Person.all.where( forenames: peerage.forenames ).where( surname: peerage.surname ).where( date_of_birth: peerage.date_of_birth ).where( date_of_death: peerage.date_of_death ).first
    unless person
      person = Person.new
      person.forenames = peerage.forenames
      person.surname = peerage.surname
      person.gender_char = peerage.gender.downcase
      person.date_of_birth = peerage.date_of_birth
      person.date_of_death = peerage.date_of_death
      person.save
    end
    peerage_holding = PeerageHolding.new
    # Given we're only dealing with first holders, set the ordinality to 1, the start date to the date of letters patent and the end date to the date of death of the person
    peerage_holding.ordinality = 1
    peerage_holding.start_on = peerage.patent_on
    peerage_holding.end_on = peerage.date_of_death
    
    # Move introduced on to holding because, although inheritees don't get introduced, they do if there's a special remainder
    peerage_holding.introduced_on = peerage.introduced_on
    peerage_holding.person = person
    peerage_holding.peerage = peerage
    peerage_holding.save
  end
end
task :populate_letters => :environment do
  puts "populating surname letters"
  letter = Letter.new
  letter.letter = "Without surname"
  letter.url_key = "-"
  letter.save
  ('A'..'Z').each do |l|
    letter = Letter.new
    letter.letter = l
    letter.url_key = l.downcase
    letter.save
  end
end
task :normalise_letters => :environment do
  puts "normalising letters from surnames"
  people = Person.all
  people.each do |person|
    if person.surname == '-' or person.surname == ''
      person.letter_id = 1
    else
      letter = Letter.all.where( letter: person.surname[0,1].upcase ).first
      person.letter = letter
    end
    person.save
  end
end
task :normalise_genders => :environment do
  puts "normalising genders from people"
  people = Person.all
  people.each do |person|
    gender = Gender.all.where( 'letter = ?', person.gender_char ).first
    person.gender = gender
    person.save
  end
end
task :populate_rank_labels => :environment do
  puts "populating rank labels"
  ranks = Rank.all
  ranks.each do |rank|
    gender = Gender.all.where( 'letter = ?', rank.gender_char.downcase ).first
    rank_label = RankLabel.new
    rank_label.label = rank.name
    rank_label.gender = gender
    rank_label.rank = rank
    rank_label.save
  end
end
task :collapse_ranks_across_genders => :environment do
  puts "collapsing ranks across genders"
  ranks = Rank.all
  ranks.each do |rank|
    # if the rank's gender is female...
    if rank.gender_char == 'F'
      
      # ...find the rank that's male with the same degree
      male_gender_rank = Rank.all.where( 'gender_char = ?', 'M' ).where( 'degree = ?', rank.degree ).first
      
      # ...loop through all peerages with the female rank
      rank.peerages.each do |peerage|
        
        # ...Set the peeraage to the male version
        peerage.rank = male_gender_rank
        peerage.save
      end
      
      # ...and again for subsidiary titles
      rank.subsidiary_titles.each do |subsidiary_title|
        
        # ...Set the peeraage to the male version
        subsidiary_title.rank = male_gender_rank
        subsidiary_title.save
      end
      
      # Find the female gender
      gender = Gender.all.where( 'label = ?', 'Female' ).first
      
      # Find the female gendered rank label
      female_rank_label = RankLabel.all.where( 'rank_id = ?', rank.id ).where( 'gender_id = ?', gender.id ).first
      
      # Point the female gendered rank label at the male rank
      female_rank_label.rank = male_gender_rank
      female_rank_label.save
      
      # nuke the female rank
      rank.destroy
    end
  end
end
task :normalise_jurisdictions_from_law_lord_incumbencies => :environment do
  puts "normalising jurisdictions from law lord incumbencies"
  law_lord_incumbencies = LawLordIncumbency.all
  law_lord_incumbencies.each do |law_lord_incumbency|
    jurisdiction = Jurisdiction.all.where( 'code = ?', law_lord_incumbency.jurisdiction_code ).first
    unless jurisdiction
      jurisdiction = Jurisdiction.new
      jurisdiction.code = law_lord_incumbency.jurisdiction_code
      jurisdiction.label = 'England and Wales' if law_lord_incumbency.jurisdiction_code == 'E&W'
      jurisdiction.label = 'Ireland' if law_lord_incumbency.jurisdiction_code == 'I'
      jurisdiction.label = 'Scotland' if law_lord_incumbency.jurisdiction_code == 'S'
      jurisdiction.label = 'Northern Ireland' if law_lord_incumbency.jurisdiction_code == 'NI'
      jurisdiction.save
    end
    law_lord_incumbency.jurisdiction = jurisdiction
    law_lord_incumbency.save
  end
end
task :normalise_special_remainders_from_peerages => :environment do
  puts "normalising special remainders from peerages"
  peerages = Peerage.all.where( 'sr is not null' )
  peerages.each do |peerage|
    special_remainder = SpecialRemainder.all.where( 'code = ?', peerage.sr ).first
    unless special_remainder
      special_remainder = SpecialRemainder.new
      special_remainder.code = peerage.sr
      special_remainder.description = 'Peerages which may be inherited by a male indirect descendant of the first holder, for example: a brother or a male cousin.' if peerage.sr == 'M'
      special_remainder.description = 'Peerages which may be inherited by a female direct descendant.' if peerage.sr == 'F'
      special_remainder.description = 'Peerages which may be inherited by a female direct descendant or a male indirect descendant.' if peerage.sr == 'B'
      special_remainder.description = 'Peerages with particular rules of inheritance set out in letters patent.' if peerage.sr == 'S'
      special_remainder.description = 'Peerages with rules of limited inheritance, for example: the 1st Baroness Abercromby, whose peerage was limited to male descendants of her late husband.' if peerage.sr == 'L'
      special_remainder.save
    end
    peerage.special_remainder = special_remainder
    peerage.save
  end
end
task :normalise_special_remainders_from_subsidiary_titles => :environment do
  puts "normalising special remainders from subsidiary titles"
  subsidiary_titles = SubsidiaryTitle.all.where( 'sr is not null' )
  subsidiary_titles.each do |subsidiary_title|
    special_remainder = SpecialRemainder.all.where( 'code = ?', subsidiary_title.sr ).first
    subsidiary_title.special_remainder = special_remainder
    subsidiary_title.save
  end
end
task :normalise_letters_patent => :environment do
  puts "normalising letters patent"
  # Pull letters patent out of peerages table
  peerages = Peerage.all
  peerages.each do |peerage|
    letters_patent = LettersPatent.new
    letters_patent.patent_on = peerage.patent_on
    letters_patent.patent_time = peerage.patent_time
    letters_patent.previous_rank = peerage.previous_rank
    letters_patent.previous_title = peerage.previous_title
    letters_patent.administration = peerage.administration
    letters_patent.announcement = peerage.announcement
    letters_patent.save
    peerage.letters_patent = letters_patent
    peerage.save
  end
  
  # Pull letters patent out of subsidiary titles table
  # NOTE: The Duke of Cambridge has a patent_on date of 2011-05-26
  # There are two subsidiary titles: the Earl of Strathearn and Lord Carrickfergus
  # Both of these have a patent_on date of 2011-04-29
  # We can only find one announcement in the London Gazette and assume this is a data entry error
  # This script will set the patent_on and patent_time for the subsidiary title to be the same as those for the parent peerage
  subsidiary_titles = SubsidiaryTitle.all
  subsidiary_titles.each do |subsidiary_title|
    subsidiary_title.letters_patent = subsidiary_title.peerage.letters_patent
    subsidiary_title.save
  end
end
task :link_announcements_to_administration => :environment do
  puts "linking announcements to administrations"
  announcements = Announcement.all
  announcements.each do |announcement|
    unless announcement.letters_patent.empty?
      announcement.administration = announcement.letters_patent.first.administration
      announcement.save
    end
  end
end
task :port_subsidiary_titles_to_peerages => :environment do
  puts "porting subsidiary title to peerages"
  subsidiary_titles = SubsidiaryTitle.all
  subsidiary_titles.each do |subsidiary_title|
    
    # create a new peerage
    peerage = Peerage.new
    peerage.title = subsidiary_title.title
    peerage.territorial_designation = subsidiary_title.territorial_designation
    peerage.of_title = subsidiary_title.of_title
    peerage.extinct_on = subsidiary_title.extinct_on
    peerage.last_number = subsidiary_title.last_number
    peerage.notes = subsidiary_title.notes
    peerage.alpha = subsidiary_title.alpha
    peerage.rank_id = subsidiary_title.rank_id
    peerage.special_remainder_id = subsidiary_title.special_remainder_id
    # Assign the same peerage type as the parent peerage
    peerage.peerage_type = subsidiary_title.peerage.peerage_type
    peerage.letters_patent_id = subsidiary_title.letters_patent_id
    peerage.save
    
    # create a new peerage holding to the same person as the parent peerage
    parent_peerage = subsidiary_title.peerage
    peerage_holding = PeerageHolding.new
    peerage_holding.peerage = peerage
    peerage_holding.person = parent_peerage.peerage_holdings.first.person
    # Given we're only dealing with first holders, set the ordinality to 1, the start date to the date of letters patent and the end date to the date of death of the person
    peerage_holding.ordinality = 1
    peerage_holding.start_on = parent_peerage.letters_patent.patent_on
    peerage_holding.end_on = parent_peerage.date_of_death
    peerage_holding.introduced_on = parent_peerage.peerage_holdings.first.introduced_on
    peerage_holding.save
  end
end
task :link_letter_patent_to_peerages => :environment do
  puts "linking letters patent to people"
  letters_patents = LettersPatent.all
  letters_patents.each do |letters_patent|
    letters_patent.person = letters_patent.peerages.first.peerage_holdings.first.person
    letters_patent.save
  end
end
task :link_peerage_to_letters => :environment do
  puts "linking peerages to letters"
  peerages = Peerage.all
  peerages.each do |peerage|
    letter = Letter.all.where( 'letter = ?', peerage.alpha[0,1].upcase ).first
    peerage.letter = letter
    peerage.save
  end
end
task :add_labels_to_ranks => :environment do
  puts "adding genderless labels to ranks"
  ranks = Rank.all
  ranks.each do |rank|
    case rank.degree
    when 0
      rank.label = 'Prince'
    when 1
      rank.label = 'Dukedom'
    when 2
      rank.label = 'Marquessate'
    when 3
      rank.label = 'Earldom'
    when 4
      rank.label = 'Viscountcy'
    when 5
      rank.label = 'Barony'
    end
    rank.save
  end
end
task :extract_letters_patent_times => :environment do
  puts "extracting times (am / pm / hour) from letters_patents.patent_time"
  letters_patents = LettersPatent.all.where( 'patent_time is not null' )
  letters_patents.each do |letters_patent|
    case letters_patent.patent_time
    when 'a', 'A'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'A' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'A'
        letters_patent_time.label = 'Morning'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    when 'p', 'P'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'P' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'P'
        letters_patent_time.label = 'Afternoon'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    when 'q', 'Q'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'Q' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'Q'
        letters_patent_time.label = '6 a.m.'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    when 'r', 'R'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'R' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'R'
        letters_patent_time.label = '9 a.m.'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    when 's', 'S'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'S' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'S'
        letters_patent_time.label = '12 noon'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    when 't', 'T'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'T' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'T'
        letters_patent_time.label = '1 p.m.'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    when 'u', 'U'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'U' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'U'
        letters_patent_time.label = '2 p.m.'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    when 'v', 'V'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'V' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'V'
        letters_patent_time.label = '3 p.m.'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    when 'w', 'W'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'W' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'W'
        letters_patent_time.label = '6 p.m.'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    when 'x', 'X'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'X' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'X'
        letters_patent_time.label = '9 p.m.'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    when 'y', 'Y'
      letters_patent_time = LettersPatentTime.all.where( 'time_code = ?', 'Y' ).first
      unless letters_patent_time
        letters_patent_time = LettersPatentTime.new
        letters_patent_time.time_code = 'Y'
        letters_patent_time.label = '11 p.m.'
        letters_patent_time.save
      end
      letters_patent.letters_patent_time = letters_patent_time
      letters_patent.save
    end
  end
end
task :downcase_letter_patent_at_time => :environment do
  puts "downcasing patent at time on letters patent"
  # patent at uses numbers to denote rank and mixed case letters to denote time / precedence.
  # we believe upper and lower case letters are equivalent so downcasing to allow better sorting.
  letters_patents = LettersPatent.all.where( 'patent_time is not null' )
  letters_patents.each do |letters_patent|
    letters_patent.patent_time.downcase!
    letters_patent.save
  end
end
task :set_letters_patent_ordinality_in_day => :environment do
  puts "setting the ordinality of letters patent issued on the same day"
  
  # Get a list of distinct dates with letters patent issued.
  letters_patent_dates = LettersPatent.all.select( 'distinct( patent_on) ' ).order( 'patent_on' )
  
  # Loop through all dates and ...
  letters_patent_dates.each do |letters_patent_date|
    
    # ... set the starting ordinality for that day to 0.
    ordinality_on_date = 0
    
    # ... find the letters patent for that date.
    letters_patents = LettersPatent.all.where( 'patent_on = ?', letters_patent_date.patent_on ).order( 'patent_time' )
    
    # ... loop through the letters patent on a date and ...
    letters_patents.each do |letters_patent|
      
      # ... increment the ordinality.
      ordinality_on_date += 1
      
      # ... save the letters patent
      letters_patent.ordinality_on_date = ordinality_on_date
      letters_patent.save
    end
  end
end
task :deprecate_princes => :environment do
  puts "marking prince as a non peerage rank"
  ranks = Rank.all
  ranks.each do |rank|
    if rank.degree == 0
      rank.is_peerage_rank = false
      rank.save
    end
  end
end
task :link_peerages_to_kingdom => :environment do
  puts "linking peerages to kingdom"
  # All David's peerages in the UK peerage.
  kingdom = Kingdom.all.where( 'name = ?', 'United Kingdom' ).first
  peerages = Peerage.all
  peerages.each do |peerage|
    peerage.kingdom = kingdom
    peerage.save
  end
end
task :link_letters_patent_to_kingdom => :environment do
  puts "linking letters_patent to kingdom"
  # All David's peerages in the UK peerage.
  kingdom = Kingdom.all.where( 'name = ?', 'United Kingdom' ).first
  letters_patents = LettersPatent.all
  letters_patents.each do |letters_patent|
    letters_patent.kingdom = kingdom
    letters_patent.save
  end
end
task :link_ranks_to_kingdoms => :environment do
  puts "linking ranks to kingdoms"
  ranks = Rank.all
  kingdoms = Kingdom.all
  ranks.each do |rank|
    kingdoms.each do |kingdom|
      # unless this is a barony in scotland...
      unless rank.degree == 5 and kingdom.id == 2
        kingdom_rank = KingdomRank.new
        kingdom_rank.kingdom = kingdom
        kingdom_rank.rank = rank
        kingdom_rank.save
      end
    end
  end
end
task :add_lordships => :environment do
  puts "adding lordship rank for scotland, rank labels for scotland and tie to Kingdom of Scotland"
  rank = Rank.new
  rank.degree = 5
  rank.label = 'Lordship'
  rank.is_peerage_rank = true
  rank.code = "something has to be here"
  rank.save
  # create new rank labels for male lordship
  rank_label = RankLabel.new
  rank_label.label = 'Lord'
  rank_label.rank = rank
  rank_label.gender_id = 1
  # create new rank labels for female lordship
  rank_label = RankLabel.new
  rank_label.label = 'Lady'
  rank_label.rank = rank
  rank_label.gender_id = 2
  rank_label.save
  kingdom_rank = KingdomRank.new
  kingdom_rank.rank = rank
  kingdom_rank.kingdom_id = 2
  kingdom_rank.save
end
task :normalise_previous_kingdoms => :environment do
  puts "normalising previous kingdom from previous rank"
  letters_patents = LettersPatent.all
  letters_patents.each do |letters_patent|
    if letters_patent.previous_rank and letters_patent.previous_rank.include?( "(S)" )
      letters_patent.previous_kingdom_id = 2
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "(S)", "")
      letters_patent.save
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "(I)" )
      letters_patent.previous_kingdom_id = 3
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "(I)", "")
      letters_patent.save
    end
  end
end
task :normalise_previous_of_title => :environment do
  puts "normalising previous of title from previous rank"
  letters_patents = LettersPatent.all
  letters_patents.each do |letters_patent|
    if letters_patent.previous_rank and letters_patent.previous_rank.include?( " of" )
      letters_patent.previous_of_title = true
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( " of", "")
      letters_patent.save
    end
  end
end
task :remove_dots_from_previous_ranks => :environment do
  puts "removing dots from previous rank"
  letters_patents = LettersPatent.all
  letters_patents.each do |letters_patent|
    if letters_patent.previous_rank and letters_patent.previous_rank.include?( "." )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( ".", "")
      letters_patent.save
    end
  end
end
task :expand_previous_titles => :environment do
  puts "expanding previous titles"
  letters_patents = LettersPatent.all
  letters_patents.each do |letters_patent|
    if letters_patent.previous_rank and letters_patent.previous_rank.include?( "Viscountess" )
      # do nothing. this is to stop expanding Viscountess to Viscountiscountess when looking for V below.
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "Lady" )
      # do nothing. this is to stop expanding Lady to Lordady when looking for L below.
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "Dss" )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "Dss", "Duchess" )
      letters_patent.save
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "Mss" )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "Mss", "Marchioness" )
      letters_patent.save
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "B" )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "B", "Baroness" )
      letters_patent.save
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "C" )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "C", "Countess" )
      letters_patent.save
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "D" )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "D", "Duke" )
      letters_patent.save
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "E" )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "E", "Earl" )
      letters_patent.save
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "L" )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "L", "Lord" )
      letters_patent.save
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "M" )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "M", "Marquess" )
      letters_patent.save
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "P" )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "P", "Prince" )
      letters_patent.save
    elsif letters_patent.previous_rank and letters_patent.previous_rank.include?( "V" )
      letters_patent.previous_rank = letters_patent.previous_rank.gsub( "V", "Viscount" )
      letters_patent.save
    end
  end
end
task :remove_incorrect_special_remainder => :environment do
  puts "removing the incorrect special remainder"
  # This is for peerages that do not have a special remainder but share a letters patent with a peerage that does. David is happy to remove.
  peerages = Peerage.all.where( 'special_remainder_id = 4' )
  peerages.each do |peerage|
    peerage.special_remainder_id = nil
    peerage.save
  end
  special_remainder = SpecialRemainder.find( 4 )
  special_remainder.destroy
  
end