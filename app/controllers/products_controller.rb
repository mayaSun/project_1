class ProductsController <ApplicationController

  def show
    @product = Product.find_by(slug: params[:id])
    @related_products = Product.all
  end

  def search
    @products = Product.search_by_name(params[:search_term]) 
    SacredSymbol.search_by_name(params[:search_term]).each do |sacred_symbol|
      @products += sacred_symbol.products.drop_while { |item| @products.include?(item) } 
    end
    Category.search_by_name(params[:search_term]).each do |category|
      @products += category.products.drop_while { |item| @products.include?(item) } 
    end
  end

end