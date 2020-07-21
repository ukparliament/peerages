class PersonController < ApplicationController
  
  def index
    @people = Person.all.order( 'surname' ).order( 'forenames' ).order( 'date_of_birth')
  end
  
  def show
    person = params[:person]
    @person = Person.find( person )
  end
end
