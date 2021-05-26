task :add_relationships => [
  :add_new_announcement_type_category,
  :link_peerages_to_administration,
  :link_peerages_to_peerage_type,
  :link_peerages_to_rank,
  :link_announcements_to_announcement_types,
  :link_peerages_to_announcement,
  :link_law_lord_incumbencies_to_peerage,
  :link_subsidiary_titles_to_rank] do
end

task :add_new_announcement_type_category => :environment do
  puts "adding new announcement type category"
  
  # There are 14 peers with an announcement type code of 'L', but no announcement type code of 'L' in the announcement types table. Lord Boothby being one example.
  # David notes: When the Life Peerages Act 1958 came into force there was an initial list of appointments which does not neatly fit into any other category. The L (short for "Life Peerages Act") relates to that list.
  # This will be rectified in later dump so first ...
  
  # ... we check if there's an announcment type with a code of 'L'.
  announcement_type = AnnouncementType.all.where( 'code = ?', 'L' ).first
  # unless there is an announcement type with code 'L' ...
  unless announcement_type
    # ... we create a new announcement type with code 'L'.
    announcement_type = AnnouncementType.new
    announcement_type.code = 'L'
    announcement_type.name = 'Initial peerages created under the Life Peerages Act 1958'
    announcement_type.save
  end
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
  # NOTE: this is all quite broke
  # 611 of 2882 peerages have no announced on date
  # 1042 of 2882 peerages have no announcement type code
  # 432 have a date but no code
  # 1 has a code and no date
  # matching only on date matches 1389 peerages to announcements
  # matching on date and type matches 1389 peerages to announcements
  # 1 peerage matches on date but not on date and code
  # 404 peerages match on code but not date
  peerages = Peerage.all
  peerages.each do |peerage|
    # If the peerage has both an announcement date and an announcement type code ...
    if peerage.announced_on and peerage.announcement_type_code
      
      # ... find an announcement with that date and type and ...
      announcement = Announcement.all.where( announced_on: peerage.announced_on ).where( announcement_type_code: peerage.announcement_type_code ).first
      
      # ... if the announcment doesn't exist ...
      unless announcement
      
        # ... create the announcement.
        # We know there are 14 peerages with an announcement type code of 'L' and 404 peerages that match a code but with no announcement for that code on that date. Creating the announcement fixes 418 matches.
        announcement_type = AnnouncementType.all.where( 'code = ?', peerage.announcement_type_code ).first
        if announcement_type
          
          announcement = Announcement.new
          announcement.announced_on = peerage.announced_on
          announcement.in_gazette = false
          # Announcement type code is not null in database so we need to add this though it serves no purpose.
          announcement.announcement_type_code = peerage.announcement_type_code
          announcement.announcement_type = announcement_type
          announcement.save
        end
      end
      
      # ... link the peerage to the announcement.
      peerage.announcement = announcement
      peerage.save
    end
  end
end
task :link_law_lord_incumbencies_to_peerage => :environment do
  puts "linking law lord incumbencies to peerages"
  law_lord_incumbencies = LawLordIncumbency.all
  law_lord_incumbencies.each do |law_lord_incumbency|
    peerage = Peerage.all.where( id: law_lord_incumbency.old_id ).first
    law_lord_incumbency.peerage = peerage
    law_lord_incumbency.save
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