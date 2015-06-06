class ApplicationMailer < ActionMailer::Base

  default from: "maya166@gmail.com"

  def contact_us_mail(params={})
    @message = params[:message]
    mail from: params[:email] , to: 'maya166@gmail.com', subject: 'Contact Us Email from:' + params[:name] + ':' + params[:subject]
  end

  def order_approval(order)
    @order = order
    mail to: order.email, subject: 'Your order approval and details'
  end

  def order_delivary_approval(order)
    @order = order
    mail to: order.email, subject: 'Your order approval and details'
  end

end