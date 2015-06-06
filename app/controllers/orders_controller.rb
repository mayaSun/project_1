class OrdersController <ApplicationController

  before_filter do
    locale = params[:locale]
    Carmen.i18n_backend.locale = locale if locale
  end

  def subregion_options
    render partial: 'subregion_select'
  end

  def show
    @order = Order.find_by(slug: params[:id])
    if ! (logged_in? && ( (@order.user && @order.user == current_user) || current_user_admin?))
      flash[:error] = "Error: Require login"
      redirect_to :back
    end 
  end

  def new
    if shopping_bag.empty?
      flash[:notice] = "Your Shopping Bag Is Empty.."
      redirect_to :back
    else
      @order = Order.new
      respond_to do |format|
        format.html 
        format.json { render json: @order }
      end
    end
  end

  def terms_and_conditions
    respond_to do |format|
      format.html
      format.js
    end 
  end

  def create
    @order = Order.new(order_params, user: logged_in? ? current_user : nil)
    if @order.valid?
      if !params[:accept_terms_and_conditions]
        flash[:error] = "Please confirm that i have read and agree with the Terms and Conditions."
        render :new
      else
        if !check_shopping_bag_stock
          render :new
        else
          session[:order_attributes] = @order.attributes 
          redirect_to '/payment'
        end
      end
    else
      render :new  
    end
  end

  def payment_new
    if shopping_bag.empty?
      flash[:notice] = "Your Shopping Bag Is Empty.."
      redirect_to :back
    end
    @order = Order.new(session[:order_attributes])
  end

  def payment_create
    @order = Order.new(session[:order_attributes])
    if check_shopping_bag_stock == true 
      charge = StripeWrapper::Charge.create(
        :card => params[:stripeToken],
        :amount => total_bill,
        :description => "order nu 12"
      )
      if charge.successful?
        @order.reference_id = charge.id
        handle_order(@order, 'stripe')
      else
        flash[:error] =  charge.error_message
        render :payment_new
      end
    else
      render :payment_new
    end
  end

    protect_from_forgery except: [:paypal_hook]

    def paypal_hook
      binding.pry
      params.permit! # Permit all Paypal input params
      status = params[:payment_status]
      if status == "Completed"
        @order = Order.new(session[:order_attributes])
        handle_order(@order,'paypal')
      else
        render nothing: true
      end  
    end

  private

  def order_params
    params.require(:order).permit(:first_name,:last_name,:address_line1,:address_line2,:city,:country_code,:state_code,:postal_code,:phone_number,:email)
  end

  def check_shopping_bag_stock  
    all_in_stock = true
    shopping_bag.each do |shopping_bag_item|
      in_stock = shopping_bag_item.product.stock
      if in_stock <  shopping_bag_item.qty
        if logged_in?
          shopping_bag_item.update(qty: in_stock)
        else
          i = session[:guest_shopping_bag_item].index(shopping_bag_item.id.to_s)
          session[:guest_shopping_bag_item_qty][i] = in_stock.to_s
        end
        flash[:error] = "Product #{shopping_bag_item.name} is now available only #{in_stock} times, your order was updated.."
        all_in_stock = false
      end     
    end
    return all_in_stock 
  end

  def add_shopping_bag_items_to_order(order)

    if logged_in?
      shopping_bag.each do |shopping_bag_item|
        shopping_bag_item.update(position: order)      
      end
    else
      shopping_bag.each do |shopping_bag_item|
        UserShoppingBagItem.create(product: shopping_bag_item.product, qty: shopping_bag_item.qty, position: order)
      end
      session[:guest_shopping_bag_item] = []
      session[:guest_shopping_bag_item_qty] = []
    end
  end

  def handle_order(order, payment_method) 
    order.status = 'paid with ' + payment_method
    order.user = current_user unless !logged_in?
    order.save
    order.update_stock
    add_shopping_bag_items_to_order(order)
    ApplicationMailer.order_approval(order).deliver
    session[:order_attributes] = nil
    flash[:notice] =  "Payment was made."
    redirect_to root_path
  end
end