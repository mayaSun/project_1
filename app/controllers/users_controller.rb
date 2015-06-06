class UsersController <ApplicationController

  respond_to :html, :js


  def new   
    @user = User.new 
    respond_to do |format|
      format.html
      format.js
    end 
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      set_user_shopping_items(@user)
      respond_to do |format|
        format.js {render 'close_user_madal.js.haml'}
      end       
    else
      respond_to do |format|
        format.js 
      end 
    end
  end

  def update
    @user = User.find_by(slug: params[:id])
    if @user == current_user || current_user_admin?
      if params[:commit] == 'Reset Password' && @user.authenticate(params[:password_authentication])
        if @user.update(password: user_params[:password], password_confirmation: user_params[:password_confirmation])
          flash[:notice] = "your password was reset"
        else
          flash[:error] = "Error: password was not reset"
        end
      elsif params[:commit] == 'Update' && @user.authenticate(params[:data_authentication])
        if @user.update(name: user_params[:name], email: user_params[:email])
          flash[:notice] = "your account data was updated"
        else
          flash[:error] = "Error: your account data was not updated"
        end
      else
        flash[:error] = "Password authentication failed"
      end
      render 'pages/my_account'
    else
      redirect_to home_path
    end  
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def ensure_current_user_or_admin(user)
    if !logged_in? || (!current_user_admin? && user != current_user)
      flash[:error] = "Error: Require login"
      redirect_to :back
    end  
  end

end