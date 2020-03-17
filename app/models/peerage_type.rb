class PeerageType < ActiveRecord::Base
  
  has_many :peerages, -> { order( :patent_on ) }
end
