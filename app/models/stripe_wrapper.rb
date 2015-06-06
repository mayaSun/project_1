module StripeWrapper 

  class Charge 

    attr_reader :status, :response

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          :amount => options[:amount], # amount in cents, again
          :currency => "usd",
          :card => options[:card],
          :description => options[:description]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, e.message)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      status
    end

    def amount
      response.amount
    end

    def currency
      response.currency
    end

    def id
      response.id
    end

  end

end 
