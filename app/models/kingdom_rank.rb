class KingdomRank < ActiveRecord::Base
  
  belongs_to :kingdom
  belongs_to :rank
end
