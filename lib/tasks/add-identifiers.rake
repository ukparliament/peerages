require 'csv'

task :add_identifiers => [
  :add_person_identifiers,
  :add_peerage_identifiers
]

task :add_person_identifiers => :environment do
  puts "adding identifiers to people"
  CSV.foreach( 'db/data/people-identifiers.csv' ) do |row|
    person = Person.find( row[0] )
    person.wikidata_id = row[1].strip
    person.rush_id = row[2].strip
    person.mnis_id = row[3].strip
    person.save
  end
end
task :add_peerage_identifiers => :environment do
  puts "adding identifiers to peerages"
  CSV.foreach( 'db/data/peerage-identifiers.csv' ) do |row|
    peerage = Peerage.find( row[0] )
    peerage.wikidata_id = row[1].strip
    peerage.save
  end
end