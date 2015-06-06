class SessionsController <ApplicationController

  def new
    reset_session
    respond_to do |format|
      format.html
      format.js
    end 
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      respond_to do |format|
        format.js {render 'close_user_madal.js.haml'}
      end 
    else
      flash.now[:error] = "Email Address dosn't match the Password"
      respond_to do |format|
        format.js 
      end
    end 
  end

  def destroy
    reset_session
    session[:user_id] = nil
    @current_user = nil
    redirect_to home_path
  end

  
end