class PersonAtozController < ApplicationController
  
  def index
    @letters = Letter.all
  end
  
  def show
    @letters = Letter.all
    letter = params[:letter]
    if letter.length == 1
      @letter = Letter.find_by_url_key( letter )
    else
      @string = letter.downcase
      @people = Person.all.where( "lower(surname) like '#{letter}%'" )
      render :template => 'person_atoz/string_match_person_show'
    end
  end
end
