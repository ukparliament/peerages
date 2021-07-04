class ReigningMonarch < ActiveRecord::Base
  
  belongs_to :monarch
  belongs_to :reign
end
