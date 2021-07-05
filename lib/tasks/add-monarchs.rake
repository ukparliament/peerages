require 'csv'

task :add_monarchs => :environment do
  puts "adding monarchs"
  CSV.foreach( 'db/data/monarchs.csv' ) do |row|
    monarch = Monarch.new
    monarch.name = row[0].strip
    monarch.date_of_birth = row[1].strip if row[1]
    monarch.date_of_death = row[2].strip if row[2]
    monarch.wikidata_id = row[3].strip if row[3]
    monarch.save
  end
end