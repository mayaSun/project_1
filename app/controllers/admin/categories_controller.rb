class Admin::CategoriesController <AdminController

  def index
    @category = Category.new
    @categories = Category.all
  end

  def show
    @category = Category.find_by(slug: params[:id])
    @products = @category.products
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category #{@category.name} was added"
      redirect_to admin_categories_path
    else
      flash[:error] = "Category #{@category.name} was NOT added"      
      @categories = Category.all 
      render :index
    end    
  end

  def edit
    @category = Category.find_by(slug: params[:id])
    @categories = Category.all
    render :index
  end

  def update
    @category = Category.find_by(slug: params[:id])
    if @category.update_attributes(category_params)
      flash[:notice] = "Category #{@category.name} was updated"
      redirect_to admin_categories_path
    else
      flash[:error] = "Category #{@category.name} was NOT updated" 
      @categories = Category.all     
      render :index
    end  
  end

  def destroy
    category = Category.find_by(slug: params[:id])
    category.delete
    flash[:notice] = "#{category.name} was deleted"
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end


end