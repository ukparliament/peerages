task :add_relationships => [
  :link_peerages_to_administration,
  :link_peerages_to_peerage_type,
  :link_peerages_to_rank,
  :link_announcements_to_announcement_types,
  :link_peerages_to_announcement,
  :link_law_lord_incumbencies_to_peerage,
  :link_subsidiary_titles_to_rank] do
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
  # One peerage has an announcement type code but no announced on date.
  # 436 peerages have an announced on date but no announcement type code.
  # 609 have neither an announced on date nor an announcement type code but we think this is expected.
  # Of the 1949 peerages having both an announcement type code and an announced on date, 560 don't have an announcement with that date and that code.
  # In this code we deal only with the 1949 peerages having both an announcement type code and an announced on date.
  peerages = Peerage.all
  peerages.each do |peerage|
    
    # If the peerage has both an announcement date and an announcement type code ...
    if peerage.announced_on and peerage.announcement_type_code
      
      # ... we try to find an announcement with that date and type and ...
      announcement = Announcement.all.where( announced_on: peerage.announced_on ).where( announcement_type_code: peerage.announcement_type_code ).first
      
      # ... if such an announcment doesn't exist ...
      unless announcement
      
        # ... we create a new announcement with the appropriate type and date.
        # This creates announcements for the 560 peerages where both values are known but there's no matching announcement.
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