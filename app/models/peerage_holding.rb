class PeerageHolding < ActiveRecord::Base
  
  belongs_to :person
  belongs_to :peerage
end
