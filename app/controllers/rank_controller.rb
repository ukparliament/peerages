class RankController < ApplicationController
  
  def index
    @ranks = Rank.all.order( 'degree' )
  end
  
  def show
    gendered_rank_label = params[:gendered_rank_label]
    @gendered_rank_label = GenderedRankLabel.find ( gendered_rank_label )
  end
  
  def peerages
    rank = params[:rank]
    @rank = Rank.find ( rank )
  end
  
  def subsidiary_titles
  end
end
