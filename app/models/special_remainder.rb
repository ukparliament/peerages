class SpecialRemainder < ActiveRecord::Base
  
  has_many :peerages, -> { order( :title ) }
end
