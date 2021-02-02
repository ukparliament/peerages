class RankController < ApplicationController
  
  def index
    @ranks = Rank.all.order( 'degree' )
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
  end
end
