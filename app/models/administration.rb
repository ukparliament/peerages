class Administration < ActiveRecord::Base
  
  has_many :peerages, -> { order( :patent_on ) }
  
  def prime_minister_ordinally
    prime_minister.gsub(/ \((.*)\)/) {|s| ', ' + s[2].to_i.ordinalize + ' administration'}
  end
  
end


