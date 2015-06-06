class ProductSymbol <ActiveRecord::Base
  belongs_to :product
  belongs_to :sacred_symbol
  validates_presence_of :product , :sacred_symbol
end