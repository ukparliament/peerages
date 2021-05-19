require 'csv'

task :wtf => :environment do
  puts "adding non-uk peerages from sainty"
  CSV.foreach( 'db/data/sainty.csv' ) do |row|
    puts row[9]
  end
end