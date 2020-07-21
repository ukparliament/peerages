task :setup => [
  :link_peerages_to_administration,
  :link_peerages_to_peerage_type,
  :link_peerages_to_rank,
  :link_announcements_to_announcement_types,
  :link_peerages_to_announcement,
  :link_law_lords_to_peerage,
  :link_subsidiary_titles_to_rank,
  :normalise_people,
  :populate_letters,
  :normalise_letters] do
end

task :link_peerages_to_administration => :environment do
  puts "linking peerages to administration"
  peerages = Peerage.all
  peerages.each do |peerage|
    administration = Administration.all.where( prime_minister: peerage.administration_name ).first
    if administration
      peerage.administration = administration
      peerage.save
    end
  end
end
task :link_peerages_to_peerage_type => :environment do
  puts "linking peerages to peerage type"
  peerages = Peerage.all
  peerages.each do |peerage|
    peerage_type = PeerageType.all.where( code: peerage.peerage_type_name.upcase ).first
    if peerage_type
      peerage.peerage_type = peerage_type
      peerage.save
    end
  end
end
task :link_peerages_to_rank => :environment do
  puts "linking peerages to rank"
  peerages = Peerage.all
  peerages.each do |peerage|
    rank = Rank.all.where( code: peerage.rank_name ).first
    peerage.rank = rank
    peerage.save
  end
end
task :link_announcements_to_announcement_types => :environment do
  puts "linking announcements to announcement types"
  announcements = Announcement.all
  announcements.each do |announcement|
    announcement_type = AnnouncementType.all.where( code: announcement.announcement_type_code ).first
    announcement.announcement_type = announcement_type
    announcement.save
  end
end
task :link_peerages_to_announcement => :environment do
  puts "linking peerages to announcements"
  # this is all quite broke
  # 611 of 2882 peerages have no announced on date
  # 1042 of 2882 peerages have no announcement type code (if this is what list_type is)
  # 432 have an date but no code
  # 1 has a code and no date
  # matching only on date matches 1389 peerages to announcements
  # matching on date and type matches 1389 peerages to announcements
  # 1 peerage matches on date but not on date and code
  # 404 peerages match on code but not date
  peerages = Peerage.all
  peerages.each do |peerage|
    if peerage.announced_on and peerage.announcement_type_code
      announcement = Announcement.all.where( announced_on: peerage.announced_on ).where( announcement_type_code: peerage.announcement_type_code ).first
      if announcement
        peerage.announcement = announcement
        peerage.save
      end
    end
  end
end
task :link_law_lords_to_peerage => :environment do
  puts "linking law lords to peerages"
  law_lords = LawLord.all
  law_lords.each do |law_lord|
    peerage = Peerage.all.where( id: law_lord.old_id ).first
    law_lord.peerage = peerage
    law_lord.save
  end
end
task :link_subsidiary_titles_to_rank => :environment do
  puts "linking subsidiary titles to ranks"
  subsidiary_titles = SubsidiaryTitle.all
  subsidiary_titles.each do |subsidiary_title|
    rank = Rank.all.where( code: subsidiary_title.rank_code).first
    subsidiary_title.rank = rank
    subsidiary_title.save
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
      person.date_of_birth = peerage.date_of_birth
      person.date_of_death = peerage.date_of_death
      person.save
    end
    peerage.person = person
    peerage.save
  end
end
task :populate_letters => :environment do
  letter = Letter.new
  letter.letter = "Without surname"
  letter.save
  ('A'..'Z').each do |l|
    letter = Letter.new
    letter.letter = l
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
      letter = Letter.all.where( letter: person.surname[0,1] ).first
      person.letter = letter
    end
    person.save
  end
end

task :check_announcments => :environment do
  puts "checking announcements"
  peerages = Peerage.all.where( 'announcement_type_code is not null' ).where( 'announced_on is not null' )
  count = 0
  peerages.each do |peerage|
    announcement_type = AnnouncementType.all.where( code: peerage.announcement_type_code )
    if announcement_type.size == 1
      announcement = Announcement.all.where( announced_on: peerage.announced_on ).first
      if announcement
        unless announcement.announcement_type_id = announcement.id
          puts "yup"
          count = count + 1
        end
      end
    end
  end
  puts count
end