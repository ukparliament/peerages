task :populate_holding_end_dates => :environment do
  puts "populating peerage holding end dates from dates of death"
  peerage_holdings = PeerageHolding.all.where( 'end_on is null' )
  peerage_holdings.each do |peerage_holding|
    if peerage_holding.person.date_of_death
      peerage_holding.end_on = peerage_holding.person.date_of_death
      peerage_holding.save
    end
  end
end