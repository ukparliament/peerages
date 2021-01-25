class Person < ActiveRecord::Base
  
  has_many :peerages, -> { order( :patent_on ) }
  belongs_to :letter
  belongs_to :gender
  
  def display_name
    "#{self.forenames} #{self.surname}"
  end
  
  def list_display
    "#{self.surname.upcase} #{self.forenames} ( #{self.date_of_birth_display} - #{self.date_of_death_display} )"
  end
  
  def date_of_birth_display
    if self.date_of_birth
      date_of_birth_display = self.date_of_birth.strftime( '%-d %b %Y')
    else
      date_of_birth_display = 'Not known'
    end
    date_of_birth_display
  end
  
  def date_of_death_display
    date_of_death_display = ''
    if self.date_of_death
      date_of_death_display += self.date_of_death.strftime( '%-d %b %Y')
    end
    date_of_death_display
  end
end
