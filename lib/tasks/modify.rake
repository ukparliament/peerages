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
  :normalise_special_remainders_from_subsidiary_titles] do
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
      opposite_gender_rank = Rank.all.where( 'gender_char = ?', 'M' ).where( 'degree = ?', rank.degree ).first
      
      # ...loop through all peerages with the female rank
      rank.peerages.each do |peerage|
        
        # ...Set the peeraage to the male version
        peerage.rank = opposite_gender_rank
        peerage.save
      end
      
      # ...and again for subsidiary titles
      rank.subsidiary_titles.each do |subsidiary_title|
        
        # ...Set the peeraage to the male version
        subsidiary_title.rank = opposite_gender_rank
        subsidiary_title.save
      end
      
      # Find the female gender
      gender = Gender.all.where( 'label = ?', 'Female' ).first
      
      # Find the female gendered rank label
      gendered_rank_label = GenderedRankLabel.all.where( 'rank_id = ?', rank.id ).where( 'gender_id = ?', gender.id ).first
      
      # Point the female gendered rank label at the male rank
      gendered_rank_label.rank = opposite_gender_rank
      gendered_rank_label.save
      
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
      special_remainder.description = 'A peerage which may be inherited by a male indirect descendant of the first holder, for example: a brother or a male cousin.' if peerage.sr == 'M'
      special_remainder.description = 'A peerage which may be inherited by a female direct descendant.' if peerage.sr == 'F'
      special_remainder.description = 'A peerage which may be inherited by a female direct descendant or a male indirect descendant.' if peerage.sr == 'B'
      special_remainder.description = 'A peerage with particular rules of inheritance set out in letters patent.' if peerage.sr == 'S'
      special_remainder.description = 'A peerage with rules of limited inheritance, for example: the 1st Baroness Abercromby, whose peerage was limited to male descendants of her late husband.' if peerage.sr == 'L'
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