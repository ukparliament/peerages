class Announcement < ActiveRecord::Base
  
  belongs_to :announcement_type
  has_many :peerages, -> { order( :patent_on ) }
  has_many :letters_patents, -> { order( :patent_on ) }
end
