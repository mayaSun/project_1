class PagesController <ApplicationController

  def home
    @best_sellers = Product.all.first(10)
    @new_products = Product.all.last(10)
  end

  def my_account
    if !logged_in?
      redirect_to home_path
    end
  end

  def my_orders
    if !logged_in?
      redirect_to home_path
    end
  end

end