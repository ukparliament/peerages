class PeerageType < ActiveRecord::Base
  
  has_many :peerages, -> { order( :alpha ) }
end
