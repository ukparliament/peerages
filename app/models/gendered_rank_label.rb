class GenderedRankLabel < ActiveRecord::Base
  
  belongs_to :rank
  belongs_to :gender
end
