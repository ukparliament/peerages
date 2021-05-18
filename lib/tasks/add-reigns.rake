require 'csv'

task :add_reigns => :environment do
  puts "adding reigns"
  CSV.foreach( 'db/data/reigns.csv' ) do |row|
    reign = Reign.new
    monarch = Monarch.find_by_name( row[0] )
    kingdom = Kingdom.find_by_name( row[3] )
    reign.monarch = monarch
    reign.kingdom = kingdom
    reign.start_on = row[1]
    reign.end_on = row[2]
    reign.save
  end
end