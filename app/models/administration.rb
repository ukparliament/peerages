class Administration < ActiveRecord::Base
  
  has_many :peerages, -> { order( :patent_on ) }
  has_many :announcements, -> { order( :announced_on ) }
  
  def prime_minister_ordinally
    prime_minister.gsub(/ \((.*)\)/) {|s| ', ' + s[2].to_i.ordinalize + ' administration'}
  end
  
  def prime_minister_reverse_ordinally
    pm = prime_minister.gsub(/(.*)\((.*)\)/) {|s| $2.to_i.ordinalize + " " +  $1 + " administration"}
    if pm == prime_minister
      pm = prime_minister + ' administration'
    end
    pm
  end
  
  def start_date_display
    if self.start_date
      start_date_display = self.start_date.strftime( '%-d %b %Y')
    else
      start_date_display = '-'
    end
    start_date_display
  end
  
  def end_date_display
    if self.end_date
      end_date_display = self.end_date.strftime( '%-d %b %Y')
    else
      end_date_display = '-'
    end
    end_date_display
  end
  
  def date_range
    date_range = self.start_date_display
    date_range += ' - '
    date_range += self.end_date_display if self.end_date
    date_range
  end
end


