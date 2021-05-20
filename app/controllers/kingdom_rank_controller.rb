class KingdomRankController < ApplicationController
  
  def index
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
    @ranks = @kingdom.ranks
  end
  
  def show
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
    rank = params[:rank]
    @rank = Rank.find( rank )
    @peerages = @kingdom.peerages_by_rank( @rank )
  end
end
