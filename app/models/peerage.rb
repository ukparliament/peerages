class Peerage < ActiveRecord::Base
  
  belongs_to :administration
  belongs_to :peerage_type
  belongs_to :rank
  belongs_to :announcement
  has_many :law_lords, -> { order( :appointed_on ) }
  has_many :subsidiary_titles, -> { order( :title ) }
end
