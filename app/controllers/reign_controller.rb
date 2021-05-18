class ReignController < ApplicationController
  
  def index
    @reigns = Reign.all.select( 'r.*, m.name as monarch_name, k.name as kingdom_name' ).joins( 'as r, monarchs as m, kingdoms as k').where( 'r.monarch_id = m.id' ).where( 'r.kingdom_id = k.id' ).order( 'r.start_on desc' )
  end
  
  def show
    reign = params[:reign]
    @reign = Reign.find( reign )
  end
end