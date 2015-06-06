class Admin::OrdersController <AdminController

  def index
    @orders = Order.last_orders
  end

  def edit
    @order = Order.find_by(slug: params[:id])
  end

  def update
    @order = Order.find_by(slug: params[:id])
    if @order.update(status: 'sent', confirmation_number: params[:confirmation_number], tracking_number: params[:tracking_number])
      ApplicationMailer.order_delivary_approval(@order).deliver
      flash[:notice] = "Package was updated"
      redirect_to admin_orders_path
    else
      flash[:error] = "Package number is invalid"
      render :edit
    end
  end

end