task :associate_letters_patent_with_reigns => :environment do
  puts "associating letters patent with reigns"
  letters_patents = LettersPatent.all
  letters_patents.each do |letters_patent|
    reign = Reign.all.where( 'kingdom_id = ?', letters_patent.kingdom_id ).where( 'start_on <= ?', letters_patent.patent_on ).where( 'end_on >= ? or end_on is null', letters_patent.patent_on ).first
    letters_patent.reign = reign
    letters_patent.save
  end
end