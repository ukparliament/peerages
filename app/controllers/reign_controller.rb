class ReignController < ApplicationController
  
  def index
    @reigns = Reign.all.select( 'r.*, k.name as kingdom_name' ).joins( 'as r, kingdoms as k' ).where( 'r.kingdom_id = k.id' ).order( 'r.start_on desc' )
  end
  
  def show
    reign = params[:reign]
    @reign = Reign.find( reign )
    @letters_patent = @reign.letters_patents

    respond_to do |format|
      format.html
      format.tsv {
        render :template => 'letters_patent/index'
      }
    end
  end
end
