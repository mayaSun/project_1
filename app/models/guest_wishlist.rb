class GuestWishlist

  attr_reader :product_id

  def initialize(params={})
    @product_id = params[:product_id].to_i
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

end