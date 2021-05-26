class Jurisdiction < ActiveRecord::Base
  
  has_many :law_lord_incumbencies
end
