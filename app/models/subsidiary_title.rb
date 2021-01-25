class SubsidiaryTitle < ActiveRecord::Base
  
  belongs_to :rank
  belongs_to :special_remainder
end
