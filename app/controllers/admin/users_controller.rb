class Admin::UsersController <AdminController

  def index
    @users = User.all.order('updated_at DESC')
  end

  def update
    user = User.find_by(slug: params[:id])
    if user.update(role: params[:role])
      flash[:notice] = "User #{user.name} role was change to #{user.role}."
    else
      flash[:error] = "Error: the user role was not changed."
    end
    @users = User.all.order('updated_at DESC')
    render :index
  end

  def orders
    @user = User.find_by(slug: params[:id])
    @orders = @user.orders('updated_at DESC')
  end

end