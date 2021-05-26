class LawLordIncumbency < ActiveRecord::Base
  
  belongs_to :peerage
  belongs_to :jurisdiction
end
