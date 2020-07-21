class Rank < ActiveRecord::Base
  
  has_many :peerages, -> { order( :patent_on ) }
  has_many :subsidiary_titles, -> { order( :patent_on ) }
  
  def gender_name
    case gender
    when "M"
    	"male"
    when "F"
    	"female"
    end
  end
  
end
