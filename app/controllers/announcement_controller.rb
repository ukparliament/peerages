class AnnouncementController < ApplicationController
  
  def index
    @announcements = Announcement.all.order( 'announced_on' )
  end
  
  def show
    announcement = params[:announcement]
    @announcement = Announcement.find ( announcement )
  end
  
  def peerages
    announcement = params[:announcement]
    @announcement = Announcement.find ( announcement )
  end
end
