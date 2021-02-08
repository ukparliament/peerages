class LettersPatent < ActiveRecord::Base
  
  # Legislation covering letters patent
  # https://www.legislation.gov.uk/uksi/1992/1730/made
  
  belongs_to :administration
  belongs_to :peerage_type
  belongs_to :announcement
  belongs_to :person
  has_many :peerages
end
