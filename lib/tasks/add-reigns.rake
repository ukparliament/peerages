require 'csv'

task :add_reigns => :environment do
  puts "adding reigns"
  CSV.foreach( 'db/data/reigns.csv' ) do |row|
    kingdom = Kingdom.find_by_name( row[4] )
    reign = Reign.all.where( 'kingdom_id = ?', kingdom.id ).where( 'start_on = ?', row[2].strip ).where( 'end_on = ?', row[3] ).first
    unless reign
      reign = Reign.new
      if row[1]
        reign.title = row[0].strip + ' and ' + row[1].strip
      else
        reign.title = row[0].strip
      end
      reign.kingdom = kingdom
      reign.start_on = row[2]
      reign.end_on = row[3]
      reign.save
    end
    monarch = Monarch.find_by_name( row[0].strip )
    reigning_monarch = ReigningMonarch.new
    reigning_monarch.reign = reign
    reigning_monarch.monarch = monarch
    reigning_monarch.save
    if row[1]
      monarch = Monarch.find_by_name( row[1] )
      reigning_monarch = ReigningMonarch.new
      reigning_monarch.reign = reign
      reigning_monarch.monarch = monarch
      reigning_monarch.save
    end
  end
end