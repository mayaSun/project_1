class UserShoppingBagItem <ActiveRecord::Base
  belongs_to :product
  belongs_to :position, :polymorphic => true
  validates_presence_of :product , :position
  validates_numericality_of :qty, {only_integer: true, greater_than_or_equal_to: 0}
  

  delegate :name, to: :product
  delegate :image, to: :product
  delegate :price, to: :product

  def total_price
    price * qty
  end

end