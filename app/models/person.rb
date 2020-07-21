class Person < ActiveRecord::Base
  
  has_many :peerages, -> { order( :patent_on ) }
  
  def display_name
    display_name = self.forenames
    display_name += ' '
    display_name += self.surname
    display_name
  end
  
  def list_display
    list_display = self.surname
    list_display += ', '
    list_display += self.forenames
    list_display += ' ('
    list_display += self.date_of_birth_display
    list_display += ' - '
    list_display += self.date_of_death_display
    list_display += ')'
    list_display
  end
  
  def date_of_birth_display
    if self.date_of_birth
      date_of_birth_display = self.date_of_birth.strftime( '%-d %B %Y')
    else
      date_of_birth_display = 'Unknown'
    end
    date_of_birth_display
  end
  
  def date_of_death_display
    date_of_death_display = ''
    if self.date_of_death
      date_of_death_display += self.date_of_death.strftime( '%-d %B %Y')
    end
    date_of_death_display
  end
end
