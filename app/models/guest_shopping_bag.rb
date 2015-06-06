class GuestShoppingBag

  attr_reader :qty, :product_id

  def initialize(params={})
    @qty = params[:qty].to_i
    @product_id = params[:product_id].to_i
  end

  def self.params_validated?(params={})
    params[:qty].to_i.is_a?(Integer) && params[:qty].to_i > 0
  end

  def product
    Product.find(product_id)
  end

  def id
    product_id
  end

  def name
    Product.find(product_id).name
  end

  def image
    Product.find(product_id).image
  end

  def price
    Product.find(product_id).price
  end

  def total_price
    qty * price
  end
end