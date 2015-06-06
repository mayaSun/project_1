class Admin::ProductsController <AdminController

  def index
    @product = Product.new
    @products = Product.all
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "#{@product.name} was added"
      redirect_to admin_products_path
    else
      flash[:error] = "The product #{@product.name} was NOT added"
      @products = Product.all
      render :index
    end  
  end

  def edit
    @product = Product.find_by(slug: params[:id])
    @products = Product.all
    render :index
  end

  def update
    @product = Product.find_by(slug: params[:id])
    if @product.update_attributes(product_params)
      flash[:notice] = "#{@product.name} was updated"
      redirect_to admin_products_path
    else
      flash[:error] = "#{@product.name} was NOT updated"
      @products = Product.all
      render :index
    end
  end

  def destroy
    product = Product.find_by(slug: params[:id])
    product.delete
    flash[:notice] = "#{product.name} was deleted"
    redirect_to admin_products_path
  end

  def stock
    @products = Product.all.order('stock')
  end

  def update_stock
    @product = Product.find_by(slug: params[:id])
    if @product.update(stock: params[:stock])
      flash[:notice] = "#{@product.name} stock was updated"
    else
      flash[:error] = "Error: #{@product.name} stock was NOT updated"
    end
    @products = Product.all.order('stock')
    render :stock

  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :category_id, :description, :image, :stock, :sacred_symbol_ids => [])
  end

end