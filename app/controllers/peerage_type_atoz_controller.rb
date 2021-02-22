class PeerageTypeAtozController < ApplicationController
  
  def index
    peerage_type = params[:peerage_type]
    @peerage_type = PeerageType.find ( peerage_type )
    @letters = Letter.all.where( 'id != 1' )
  end
  
  def show
    peerage_type = params[:peerage_type]
    @peerage_type = PeerageType.find ( peerage_type )
    @letters = Letter.all.where( 'id != 1' )
    letter = params[:letter]
    @letter = Letter.find_by_url_key( letter )
  end
end
