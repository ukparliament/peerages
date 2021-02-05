class PeerageAtozController < ApplicationController
  
  def index
    @letters = Letter.all.where( 'id != 1' )
  end
  
  def show
    @letters = Letter.all.where( 'id != 1' )
    letter = params[:letter]
    if letter.length == 1
      @letter = Letter.find_by_url_key( letter )
    else
      @string = letter.downcase
      @peerages = Peerage.all.where( "lower(title) like '#{letter}%'" ).order( 'title' )
      render :template => 'peerage_atoz/string_match_peerage_show'
    end
  end
end
