class RankController < ApplicationController
  
  def index
    @ranks = Rank.all.order( 'degree' ).order( 'name' )
  end
  
  def show
    rank = params[:rank]
    @rank = Rank.find ( rank )
  end
  
  def peerages
    rank = params[:rank]
    @rank = Rank.find ( rank )
  end
  
  def subsidiary_titles
    rank = params[:rank]
    @rank = Rank.find ( rank )
  end
end
