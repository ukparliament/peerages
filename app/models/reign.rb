class Reign < ActiveRecord::Base
  
  belongs_to :kingdom
  belongs_to :monarch
end
