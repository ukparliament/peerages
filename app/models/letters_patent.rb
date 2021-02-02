class LettersPatent < ActiveRecord::Base
  
  belongs_to :administration
  belongs_to :peerage_type
  belongs_to :announcement
  belongs_to :person
  has_many :peerages
end
