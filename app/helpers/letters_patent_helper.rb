module LettersPatentHelper
  
  def full_previous_title( letters_patent )
    full_previous_title = ''
    full_previous_title += letters_patent.previous_rank if letters_patent.previous_rank
    full_previous_title += ' of' if letters_patent.previous_of_title
    full_previous_title += ' ' + letters_patent.previous_title if letters_patent.previous_title
    if letters_patent.previous_kingdom
      full_previous_title += ' in the Peerage of the '
      full_previous_title += link_to( letters_patent.previous_kingdom.name, kingdom_show_url( :kingdom => letters_patent.previous_kingdom ) )
    end
    full_previous_title
  end
end
