class RankController < ApplicationController
  
  def index
    @ranks = Rank.all.where( 'is_peerage_rank is true' ).order( 'degree' )
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
