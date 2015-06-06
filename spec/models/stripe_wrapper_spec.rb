require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do

      let(:token) do
        Stripe::Token.create(
          :card => {
              :number => card_number,
              :cvs => '123',
              :exp_month => '12',
              :exp_year => '18'
            }).id
      end

      context "with valid input" do

        let(:card_number) { 4242424242424242 }
        it "charge the card", :vcr do
          response = StripeWrapper::Charge.create(amount: 999, card: token, description: "Registration Payment")
          expect(response).to be_successful
          expect(response.amount).to eq(999)
          expect(response.currency).to eq('usd')
        end
      end

      context "with invalid input" do

        let(:card_number) { 4000000000000069 }
        it "doe's not charge with declined card", :vcr do
          response = StripeWrapper::Charge.create(amount: 999, card: token, description: "Registration Payment")
          expect(response).to_not be_successful
        end

      end
    end
  end
end