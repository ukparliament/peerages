class Letter < ActiveRecord::Base
  
  has_many :people, -> { order( :surname, :forenames, :date_of_birth ) }
  has_many :peerages, -> { order( :title ) }
end
