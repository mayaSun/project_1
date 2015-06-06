class ContactUsController <ApplicationController

  def create
    if !params[:name] || !params[:email] || !params[:subject] || !params[:message] || params[:name].empty? || params[:email].empty? || params[:subject].empty? || params[:message].empty?
      flash[:error] = "Please fill all the fields in the form"
      render :new
    else
      ApplicationMailer.contact_us_mail(params).deliver
      flash[:notice] = "your massage was sent"
      redirect_to contact_us_path
    end
  end

end