class AnnouncementController < ApplicationController
  
  def index
    @announcements = Announcement.all.order( 'announced_on' )
  end
  
  def show
    announcement = params[:announcement]
    @announcement = Announcement.find ( announcement )
    @letters_patent = @announcement.letters_patents

    respond_to do |format|
      format.html
      format.tsv {
        render :template => 'letters_patent/index'
      }
    end
  end
  
  def peerages
    announcement = params[:announcement]
    @announcement = Announcement.find ( announcement )
  end
end
