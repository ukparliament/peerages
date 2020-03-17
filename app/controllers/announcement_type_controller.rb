class AnnouncementTypeController < ApplicationController
  
  def index
    @announcement_types = AnnouncementType.all
  end
  
  def show
    announcement_type = params[:announcement_type]
    @announcement_type = AnnouncementType.find ( announcement_type )
  end
  
  def announcements
    announcement_type = params[:announcement_type]
    @announcement_type = AnnouncementType.find ( announcement_type )
  end
end
