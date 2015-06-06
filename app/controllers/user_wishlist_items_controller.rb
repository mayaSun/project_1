class UserWishlistItemsController <ApplicationController

  def index
    if logged_in?
      @wishlist = current_user.user_wishlist_items
    else
      @wishlist = session[:guest_wishlist_item].map.with_index{|x,i| GuestWishlist.new(product_id: session[:guest_wishlist_item][i])}
    end  
  end

  def create
    if logged_in?
      wishlist_item = current_user.user_wishlist_items.new(product_id: params[:product_id])
      if wishlist_item.save
        flash[:notice] = "#{wishlist_item.name} is all ready in your Wishlist"
      else
        flash[:error] = "The product was not added to your wishlist"
      end
    else
      if session[:guest_wishlist_item].index(params[:product_id].to_s)
        flash[:error] = "Product is all ready in your wishlist"
      else
        session[:guest_wishlist_item][session[:guest_wishlist_item].size] = params[:product_id]
        flash[:notice] = "The product was added to your Wishlist"
      end
    end
    redirect_to :back  
  end

  def destroy
    if logged_in?
      wishlist_item = UserWishlistItem.find(params[:id])
      if params[:add_to_bag]
        shopping_bag_item = UserShoppingBagItem.new(position: current_user, product_id: wishlist_item.product_id, qty: 1)
        if shopping_bag_item.save
          flash[:notice] = "#{wishlist_item.name} was added to your Shopping Bag!"
        end
      else
        flash[:notice] = "#{wishlist_item.name} was removed from your Wishlist"
      end
      wishlist_item.destroy
    else
      if params[:add_to_bag]
        session[:guest_shopping_bag_item][session[:guest_shopping_bag_item].size] = params[:id]
        session[:guest_shopping_bag_item_qty][session[:guest_shopping_bag_item_qty].size] = 1
        flash[:notice] = "The product was added to your Shopping Bag!"
      else
        flash[:notice] = "The product was removed from your Wishlist"
      end
      session[:guest_wishlist_item].delete(params[:id])
    end
    redirect_to :back
  end

end