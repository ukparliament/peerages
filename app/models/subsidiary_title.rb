class SubsidiaryTitle < ActiveRecord::Base
  
  belongs_to :rank
  belongs_to :peerage
end
