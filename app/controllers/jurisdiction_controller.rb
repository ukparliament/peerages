class JurisdictionController < ApplicationController
  
  def index
    @jurisdictions = Jurisdiction.all.order( 'label' )
  end
  
  def show
    jurisdiction = params[:jurisdiction]
    @jurisdiction = Jurisdiction.find( jurisdiction )
  end
end
