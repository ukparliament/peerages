require 'csv'

task :add_monarchs => :environment do
  puts "adding monarchs"
  CSV.foreach( 'db/data/monarchs.csv' ) do |row|
    monarch = Monarch.new
    monarch.name = row[0]
    monarch.save
  end
end