class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  helper_method  :logged_in?, :current_user, :current_user_admin?, :shopping_bag, :total_bill, :wishlist_count, :shop_owner? 
  before_filter :set_session_verables

  def set_session_verables
    if !session[:guest_shopping_bag_item]
      session[:guest_shopping_bag_item] = []
      session[:guest_shopping_bag_item_qty] = []
      session[:guest_wishlist_item] = []
    end
  end

  def record_not_found
    render '404', status: 404
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end  

  def logged_in?
    !!current_user
  end

  def current_user_admin?
    current_user.role == "admin" || current_user.role == "shop_owner" 
  end

  def shop_owner?(user)
    user.role == "shop_owner" 
  end

  def shopping_bag
    if logged_in?
      current_user.user_shopping_bag_items
    else
      session[:guest_shopping_bag_item].map.with_index{|x,i| GuestShoppingBag.new(product_id: session[:guest_shopping_bag_item][i], qty: session[:guest_shopping_bag_item_qty][i])}
    end
  end

  def total_bill
    if logged_in?
      current_user.total_bill
    else
      shopping_bag.map(&:total_price).inject(0, :+)
    end
  end

  def set_user_shopping_items(user)
    session[:guest_shopping_bag_item].each_index do |i|
      UserShoppingBagItem.create(position: user,product_id: session[:guest_shopping_bag_item][i].to_i, qty: session[:guest_shopping_bag_item_qty][i].to_i)    
    end
    session[:guest_wishlist_item].each_index do |i|
      user.user_wishlist_items.create(product_id: session[:guest_wishlist_item][i].to_i)    
    end
    session[:guest_shopping_bag_item].clear
    session[:guest_shopping_bag_item_qty].clear
    session[:guest_wishlist_item].clear
  end

  def wishlist_count
    if logged_in?
      current_user.user_wishlist_items.count
    else
      session[:guest_wishlist_item].count
    end
  end
end
