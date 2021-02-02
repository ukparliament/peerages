class Peerage < ActiveRecord::Base
  
  belongs_to :administration
  belongs_to :peerage_type
  belongs_to :rank
  belongs_to :announcement
  belongs_to :special_remainder
  belongs_to :letters_patent
  has_many :law_lords, -> { order( :appointed_on ) }
  has_many :subsidiary_titles, -> { order( :title ) }
  has_many :peerage_holdings
  
  def possible_rank_titles
    # if the peerage is hered
      # if it is hered need to check if it has a special remainder that can pass to female
        # need to show both titles?
      # else
        # show male title
      # end
      # any female hereds with peerage with no special remainder?
      # if it's not hered
        # base title on gender of holder
      
    possible_rank_titles = ''
    self.rank.gendered_rank_labels.each do |grl|
      possible_rank_titles += grl.label
    end
    possible_rank_titles
  end
  
  def full_title
    full_title = self.possible_rank_titles + ' '
    full_title += ' of ' if self.of_title 
    full_title += title
    full_title += ' ' + self.of_place if self.of_place
    full_title
  end
  
  def gendered_full_title( gender )
    gendered_full_title = self.gendered_rank_label( gender ) + ' '
    gendered_full_title += ' of ' if self.of_title 
    gendered_full_title += title
    gendered_full_title += ' ' + self.of_place if self.of_place
    gendered_full_title
  end
  
  def gendered_rank_label( gender )
    GenderedRankLabel.all.where( 'gender_id = ?', gender ).where( 'rank_id = ?', self.rank.id ).first.label
  end
end
