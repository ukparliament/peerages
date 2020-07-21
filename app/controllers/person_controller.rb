class PersonController < ApplicationController
  
  def index
    @people = Person.all.order( 'surname' ).order( 'forenames' )
  end
  
  def show
    person = params[:person]
    @person = Person.find( person )
  end
end
