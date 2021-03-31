class RankController < ApplicationController
  
  def index
    @ranks = Rank.all.where( 'is_peerage_rank is true' ).order( 'degree' )
    
    # TODO: only list ranks where is_peerage_rank is TRUE
  end
  
  def show
    rank = params[:rank]
    @rank = Rank.find ( rank )
  end
  
  def peerages
    rank = params[:rank]
    @rank = Rank.find ( rank )
  end
end
