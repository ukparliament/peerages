class SubsidiaryTitle < ActiveRecord::Base
  
  belongs_to :rank
  belongs_to :special_remainder
  belongs_to :letters_patent
  belongs_to :peerage
end
