class PeerageType < ActiveRecord::Base
  
  has_many :peerages, -> { order( :title ) }
  
  def peerages_with_letter( letter )
    Peerage.all.where( 'peerage_type_id = ?', self ).where( 'letter_id = ?', letter ).order( 'title' )
  end
end
