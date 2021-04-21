class KingdomPeerageAtozController < ApplicationController
  
  def index
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
    @letters = Letter.all.where( 'id != 1' )
  end
  
  def show
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
    letter = params[:letter]
    @letter = Letter.find_by_url_key( letter )
    @letters = Letter.all.where( 'id != 1' )
    @peerages = @kingdom.peerages_by_letter( @letter )
    puts @peerages.size
  end
end
