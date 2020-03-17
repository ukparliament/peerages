class AdministrationController < ApplicationController
  
  def index
    @administrations = Administration.all.order( 'number' )
  end
  
  def show
    administration = params[:administration]
    @administration = Administration.find ( administration )
  end
  
  def peerages
    administration = params[:administration]
    @administration = Administration.find ( administration )
  end
end
