class Peerage < ActiveRecord::Base
  
  belongs_to :administration
  belongs_to :peerage_type
  belongs_to :rank
  belongs_to :announcement
  belongs_to :special_remainder
  belongs_to :letters_patent
  belongs_to :letter
  has_many :law_lords, -> { order( :appointed_on ) }
  has_many :subsidiary_titles, -> { order( :title ) }
  has_many :peerage_holdings
  
  def is_hereditary?
    is_hereditary = true
    is_hereditary = false if [1,5,6].include?self.peerage_type_id
    is_hereditary
  end
  
  def gender_of_first_holder
    self.letters_patent.person.gender
  end
  
  def can_switch_gender?
    can_switch_gender = false
    # if the peerage is hered ...
    # Array contains ids for peerage types of Hereditory Peerage, Hereditary peerage (already peer of Ireland), Hereditary peerage (already peer of Scotland), New hereditary peerage: not a promotion and Promotion are all hereditories
    # NOTE: question over promotion here
    if [2,3,4,7,8].include?( self.peerage_type_id )
      # ... if the first holder was female
      if self.gender_of_first_holder.label == 'Female'
        can_switch_gender = true
      # ... otherwise if the first holder was male
      else
        # ... if the peerage has a special remainder ...
        if self.special_remainder
          # ... if the special remainder is of the nature that the peerage can pass to females
          # assumption here that special remainders with nature set out in patent may descend to a female
          # assumption that limited inheritance peerages cannot
          if [2,4].include?( self.special_remainder_id )
            can_switch_gender = true
          end
        end
      end
    end
    can_switch_gender
  end
  
  def gendered_rank_label( gender )
    GenderedRankLabel.all.where( 'gender_id = ?', gender ).where( 'rank_id = ?', self.rank.id ).first.label
  end
  
  def opposite_gendered_rank_label( gender )
    GenderedRankLabel.all.where( 'gender_id != ?', gender ).where( 'rank_id = ?', self.rank.id ).first.label
  end
  
  def possible_rank_titles
    # set the possible rank titles according to gender of first holder
    possible_rank_titles = self.gendered_rank_label( self.gender_of_first_holder )
    # if the peerage can switch gender
    if self.can_switch_gender?
      # ... add the opposite gendered rank title
      possible_rank_titles += ' / ' + self.opposite_gendered_rank_label( self.gender_of_first_holder )
    end
    possible_rank_titles
  end
  
  def display_title
    full_title = ''
    full_title += 'of ' if self.of_title 
    full_title += title
    full_title += " (" + self.rank.label + ")"
    full_title
  end
  
  def alpha_display_title
    alpha_display_title = ''
    alpha_display_title += 'of ' if self.of_title 
    alpha_display_title += title
    alpha_display_title += " (" + self.rank.label + ")"
    alpha_display_title
  end
  
  def gendered_display_title( gender )
    full_title = self.gendered_rank_label( gender )
    full_title += ' of ' if self.of_title 
    full_title += ' ' + title
    full_title
  end
  
  def full_title
    full_title = ''
    full_title += ' of ' if self.of_title 
    full_title += title
    full_title += ', ' + self.territorial_designation if self.territorial_designation
    full_title += " (" + self.rank.label + ")"
    full_title
  end
end
