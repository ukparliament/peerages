task :modify => [
  :collapse_title_of_into_peerage,
  :normalise_people,
  :populate_letters,
  :normalise_letters,
  :normalise_genders,
  :populate_gendered_rank_labels,
  :collapse_ranks_across_genders,
  :normalise_jurisdictions_from_law_lords,
  :normalise_special_remainders_from_peerages,
  :normalise_special_remainders_from_subsidiary_titles,
  :normalise_letters_patent,
  :port_subsidiary_titles_to_peerages,
  :link_letter_patent_to_peerages,
  :link_peerage_to_letters] do
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
task :populate_gendered_rank_labels => :environment do
  puts "populating gendered rank labels"
  ranks = Rank.all
  ranks.each do |rank|
    gender = Gender.all.where( 'letter = ?', rank.gender_char.downcase ).first
    gendered_rank_label = GenderedRankLabel.new
    gendered_rank_label.label = rank.name
    gendered_rank_label.gender = gender
    gendered_rank_label.rank = rank
    gendered_rank_label.save
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
      female_rank_label = GenderedRankLabel.all.where( 'rank_id = ?', rank.id ).where( 'gender_id = ?', gender.id ).first
      
      # Point the female gendered rank label at the male rank
      female_rank_label.rank = male_gender_rank
      female_rank_label.save
      
      # nuke the female rank
      rank.destroy
    end
  end
end
task :normalise_jurisdictions_from_law_lords => :environment do
  puts "normalising jurisdictions from law lords"
  law_lords = LawLord.all
  law_lords.each do |law_lord|
    jurisdiction = Jurisdiction.all.where( 'code = ?', law_lord.jurisdiction_code ).first
    unless jurisdiction
      jurisdiction = Jurisdiction.new
      jurisdiction.code = law_lord.jurisdiction_code
      jurisdiction.label = 'England and Wales' if law_lord.jurisdiction_code == 'E&W'
      jurisdiction.label = 'Ireland' if law_lord.jurisdiction_code == 'I'
      jurisdiction.label = 'Scotland' if law_lord.jurisdiction_code == 'S'
      jurisdiction.label = 'Northern Ireland' if law_lord.jurisdiction_code == 'NI'
      jurisdiction.save
    end
    law_lord.jurisdiction = jurisdiction
    law_lord.save
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
    letters_patent.peerage_type = peerage.peerage_type
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
    peerage.letters_patent_id = subsidiary_title.letters_patent_id
    peerage.save
    
    # create a new peerage holding to the same person as the parent peerage
    parent_peerage = subsidiary_title.peerage
    peerage_holding = PeerageHolding.new
    peerage_holding.peerage = peerage
    peerage_holding.person = parent_peerage.peerage_holdings.first.person
    # NOTE: Are subsidiary peerages also introduced? Assuming so here
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









