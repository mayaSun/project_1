class UserShoppingBagItemsController <ApplicationController

  def index
  end

  def create   
    if logged_in?
      @shopping_bag_item = UserShoppingBagItem.new(position: current_user,product_id: params[:product_id], qty: params[:qty])
      if @shopping_bag_item.save
        flash[:notice] = "Product was added to your shopping bag"
      else
        flash[:error] = "Qty must be positive whole number"
      end
    else
      if GuestShoppingBag.params_validated?(params)
        if session[:guest_shopping_bag_item].index(params[:product_id].to_s)
           flash[:error] = "Product is all ready in your shopping bag"
        else
          session[:guest_shopping_bag_item][session[:guest_shopping_bag_item].size] = params[:product_id]
          session[:guest_shopping_bag_item_qty][session[:guest_shopping_bag_item_qty].size] = params[:qty]
          flash[:notice] = "Product was added to your shopping bag"
        end
      else
        flash[:error] = "Qty must be positive whole number"
      end      
    end
    redirect_to :back  
  end

  def update
    if logged_in?
      @shopping_bag_item = UserShoppingBagItem.find(params[:id])
      if @shopping_bag_item.update_attributes(qty: params[:qty])
       flash[:notice] = "Shopping Bag item quantity was updated"
      else
        flash[:error] = "Qty must be positive whole number"
      end 
    else
      if GuestShoppingBag.params_validated?(params)
        i = session[:guest_shopping_bag_item].index(params[:id])
        session[:guest_shopping_bag_item_qty][i] = params[:qty]
        flash[:notice] = "Shopping Bag item quantity was updated"
      else
        flash[:error] = "Qty must be positive whole number"
      end
    end
    redirect_to :back
  end 

  def destroy
    if logged_in?
      @shopping_bag_item = UserShoppingBagItem.find(params[:id])
      @shopping_bag_item.destroy
    else
      i = session[:guest_shopping_bag_item].index(params[:id])
      session[:guest_shopping_bag_item].delete_at(i)
      session[:guest_shopping_bag_item_qty].delete_at(i)
    end
    flash[:notice] = "Item was removed from your shopping bag"
    redirect_to :back
  end

end
