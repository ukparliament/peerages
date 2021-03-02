class Rank < ActiveRecord::Base
  
  has_many :peerages, -> { order( :alpha ) }
  has_many :subsidiary_titles, -> { order( :patent_on ) }
  has_many :gendered_rank_labels
  
  def male_gendered_label
    self.gendered_rank_labels.where( 'gender_id = 1' ).first
  end
  
  def female_gendered_label
    self.gendered_rank_labels.where( 'gender_id = 2' ).first
  end
end
