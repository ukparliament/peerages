class Rank < ActiveRecord::Base
  
  has_many :peerages, -> { order( :alpha ) }
  has_many :subsidiary_titles, -> { order( :patent_on ) }
  has_many :gendered_rank_labels
  has_many :kingdom_ranks
  has_many :kingdoms, :through => 'kingdom_ranks'
  
  def male_gendered_label
    self.gendered_rank_labels.where( 'gender_id = 1' ).first
  end
  
  def female_gendered_label
    self.gendered_rank_labels.where( 'gender_id = 2' ).first
  end
  
  def label_with_kingdoms
    label = self.label
    # Only list kingdoms if the rank doesn't apply to all of them.
    #if self.kingdoms.size < 5
      label += ' - '
      self.kingdoms.each do |kingdom|
        label += kingdom.name
        label += ', ' unless kingdom == self.kingdoms.last
      end
      #end
    label
  end
end
