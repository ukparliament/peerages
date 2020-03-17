class AnnouncementType < ActiveRecord::Base
  
  has_many :announcements, -> { order( :announced_on ) }
end
