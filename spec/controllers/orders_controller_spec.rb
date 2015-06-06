require 'spec_helper'

describe OrdersController do

  before do
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  describe 'GET new' do

    context "with non-empty shopping bag" do

      let(:product) {Fabricate(:product)}
      before do
        session[:guest_shopping_bag_item] = []
        session[:guest_shopping_bag_item_qty] = []
        session[:guest_shopping_bag_item][0] = product.id.to_s
        session[:guest_shopping_bag_item_qty][0] = 2.to_s
      end

      it "set the @order veriable" do
        get :new
        expect(assigns(:order)).to be_instance_of(Order)
      end

      it "render new" do
        get :new
        expect(response).to render_template :new
      end
    end

    context "with empty shopping bag" do
      it "redirects back to the referring page" do
        get :new
        expect(response).to redirect_to "where_i_came_from"
      end

      it "set notice message" do
        get :new
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe 'POST create' do
    context "with valid params" do

      let(:order_attributes) {Fabricate.attributes_for(:order)}
      before do
        post :create, order: order_attributes, accept_terms_and_conditions: true 
      end

      it "set the @order veriable" do
        expect(assigns(:order)).to be_instance_of(Order)
      end

      it "set session[order_attributes]" do
        expect(session[:order_attributes]["address_line1"]).to eq(order_attributes[:address_line1])
        expect(session[:order_attributes]["address_line2"]).to eq(order_attributes[:address_line2])
        expect(session[:order_attributes]["city"]).to eq(order_attributes[:city])
        expect(session[:order_attributes]["country_code"]).to eq(order_attributes[:country_code])
        expect(session[:order_attributes]["email"]).to eq(order_attributes[:email])
        expect(session[:order_attributes]["first_name"]).to eq(order_attributes[:first_name])
        expect(session[:order_attributes]["last_name"]).to eq(order_attributes[:last_name])
        expect(session[:order_attributes]["phone_number"]).to eq(order_attributes[:phone_number])
        expect(session[:order_attributes]["postal_code"]).to eq(order_attributes[:postal_code])
        expect(session[:order_attributes]["state_code"]).to eq(order_attributes[:state_code])
      end
      
      it "does not create a order in the database" do
        expect(Order.count).to eq(0)
      end

      it "redirect to payment new" do
        expect(response).to redirect_to payment_path
      end
    end

    context "with invalid params" do

      let(:order_attributes) {Fabricate.attributes_for(:order, city: nil)}
      before do
        post :create, order: order_attributes 
      end

      it "render template new" do
        expect(response).to render_template :new
      end

      it "does not set session[order_attributes]" do
        expect(session[:order_attributes]).to be_nil
      end

      it "does not create a order in the database" do
        expect(Order.count).to eq(0)
      end
    end

    context "without confirmation of the term and condition" do
      let(:order_attributes) {Fabricate.attributes_for(:order)}
      before do
        post :create, order: order_attributes 
      end

      it "set error message" do
        expect(flash[:error]).to be_present
      end

      it "render template new" do
        expect(response).to render_template :new
      end

      it "does not set session[order_attributes]" do
        expect(session[:order_attributes]).to be_nil
      end

      it "does not create a order in the database" do
        expect(Order.count).to eq(0)
      end
    end

    context "with out of stock product" do
    
      let(:product) {Fabricate(:product, stock: 2)}
      let(:order_attributes) {Fabricate.attributes_for(:order)}
      before do
        session[:guest_shopping_bag_item] = []
        session[:guest_shopping_bag_item_qty] = []
        session[:guest_shopping_bag_item][0] = product.id.to_s
        session[:guest_shopping_bag_item_qty][0] = 3.to_s
        post :create, order: order_attributes, accept_terms_and_conditions: true
      end                  

      it "fix the user shopping bag item qty" do
        expect(session[:guest_shopping_bag_item_qty][0]).to eq("2")
      end

      it "set error message" do
        expect(flash[:error]).to be_present
      end

      it "render template new" do
        expect(response).to render_template :new
      end
    end    
  end

  describe 'GET payment_new' do

    context "non-empty shopping bag" do
      it "set @order parameter" do
        product = Fabricate(:product)
        session[:guest_shopping_bag_item] = []
        session[:guest_shopping_bag_item_qty] = []
        session[:guest_shopping_bag_item][0] = product.id.to_s
        session[:guest_shopping_bag_item_qty][0] = 3.to_s
        get :payment_new
        expect(assigns(:order)).to be_instance_of(Order) 
      end
    end
    
    context "with empty shopping bag" do
      it "redirects back to the referring page" do
        get :payment_new
        expect(response).to redirect_to "where_i_came_from"
      end

      it "set notice message" do
        get :payment_new
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe 'POST payment_create' do

    context "with valid input" do
  
      let(:product1) {Fabricate(:product, stock: 5)}
      let(:product2) {Fabricate(:product, stock: 10)}
      let(:order_attributes) {Fabricate.attributes_for(:order)}
      let(:charge) { double(:charge, successful?: true, id: '65d56fr')}
      before do
        session[:guest_shopping_bag_item] = []
        session[:guest_shopping_bag_item_qty] = []
        session[:guest_shopping_bag_item][0] = product1.id.to_s
        session[:guest_shopping_bag_item_qty][0] = 3.to_s
        session[:guest_shopping_bag_item][1] = product2.id.to_s
        session[:guest_shopping_bag_item_qty][1] = 3.to_s
        session[:order_attributes] = order_attributes
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :payment_create, stripeToken: '123456'
      end

      it "save the order" do
        expect(Order.count).to eq(1)
        expect(Order.first.address_line1).to eq(order_attributes[:address_line1])
        expect(Order.first.address_line2).to eq(order_attributes[:address_line2])
        expect(Order.first.city).to eq(order_attributes[:city])
        expect(Order.first.country_code).to eq(order_attributes[:country_code])
        expect(Order.first.email).to eq(order_attributes[:email])
        expect(Order.first.first_name).to eq(order_attributes[:first_name])
        expect(Order.first.last_name).to eq(order_attributes[:last_name])
        expect(Order.first.phone_number).to eq(order_attributes[:phone_number])
        expect(Order.first.postal_code).to eq(order_attributes[:postal_code])
        expect(Order.first.state_code).to eq(order_attributes[:state_code])
      end

      it "delete session[:order_attribute]" do
        expect(session[:order_attributes]).to be_nil
      end

      it "empty the shopping bag" do
        expect(session[:guest_shopping_bag_item]).to eq([])
        expect(session[:guest_shopping_bag_item_qty]).to eq([])
      end

      it "set notice message" do  
        expect(flash[:notice]).to be_present
      end

      it "redirect to root" do
        expect(response).to redirect_to root_path
      end
    end

    context "with item not in stock" do
      let(:product1) {Fabricate(:product, stock: 2)}
      let(:product2) {Fabricate(:product, stock: 3)}
      let(:order_attributes) {Fabricate.attributes_for(:order)}
      before do
        session[:guest_shopping_bag_item] = []
        session[:guest_shopping_bag_item_qty] = []
        session[:guest_shopping_bag_item][0] = product1.id.to_s
        session[:guest_shopping_bag_item_qty][0] = 3.to_s
        session[:guest_shopping_bag_item][1] = product2.id.to_s
        session[:guest_shopping_bag_item_qty][1] = 3.to_s
        session[:order_attributes] = order_attributes
        post :payment_create, stripeToken: '123456'
      end

      it "does not save the order" do
        expect(Order.count).to eq(0)
      end

      it "does not delete session[:order_attribute]" do
        expect(session[:order_attributes]["address_line1"]).to eq(order_attributes[:address_line1])
        expect(session[:order_attributes]["address_line2"]).to eq(order_attributes[:address_line2])
        expect(session[:order_attributes]["city"]).to eq(order_attributes[:city])
        expect(session[:order_attributes]["country_code"]).to eq(order_attributes[:country_code])
        expect(session[:order_attributes]["email"]).to eq(order_attributes[:email])
        expect(session[:order_attributes]["first_name"]).to eq(order_attributes[:first_name])
        expect(session[:order_attributes]["last_name"]).to eq(order_attributes[:last_name])
        expect(session[:order_attributes]["phone_number"]).to eq(order_attributes[:phone_number])
        expect(session[:order_attributes]["postal_code"]).to eq(order_attributes[:postal_code])
        expect(session[:order_attributes]["state_code"]).to eq(order_attributes[:state_code])
      end

      it "does not empty the shopping bag" do
        expect(session[:guest_shopping_bag_item][0]).to eq(product1.id.to_s)
        expect(session[:guest_shopping_bag_item][1]).to eq(product2.id.to_s)
        expect(session[:guest_shopping_bag_item_qty][1]).to eq(3.to_s)
      end

      it "update the qty of the shopping bag item" do
        expect(session[:guest_shopping_bag_item_qty][0]).to eq(2.to_s)
      end

      it "set error message" do
        expect(flash[:error]).to be_present
      end

      it "render template payment_new" do
        expect(response).to render_template :payment_new
      end

    end

    context "with invalid card" do
      let(:product) {Fabricate(:product, stock: 5)}
      let(:order_attributes) {Fabricate.attributes_for(:order)}
      let(:charge) { double(:charge, successful?: false, error_message: "invalid card")}
      before do
        session[:guest_shopping_bag_item] = []
        session[:guest_shopping_bag_item_qty] = []
        session[:guest_shopping_bag_item][0] = product.id.to_s
        session[:guest_shopping_bag_item_qty][0] = 3.to_s
        session[:order_attributes] = order_attributes
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :payment_create, stripeToken: '123456'
      end

      it "does not save the order" do
        expect(Order.count).to eq(0)
      end

      it "does not delete session[:order_attribute]" do
        expect(session[:order_attributes]["address_line1"]).to eq(order_attributes[:address_line1])
        expect(session[:order_attributes]["address_line2"]).to eq(order_attributes[:address_line2])
        expect(session[:order_attributes]["city"]).to eq(order_attributes[:city])
        expect(session[:order_attributes]["country_code"]).to eq(order_attributes[:country_code])
        expect(session[:order_attributes]["email"]).to eq(order_attributes[:email])
        expect(session[:order_attributes]["first_name"]).to eq(order_attributes[:first_name])
        expect(session[:order_attributes]["last_name"]).to eq(order_attributes[:last_name])
        expect(session[:order_attributes]["phone_number"]).to eq(order_attributes[:phone_number])
        expect(session[:order_attributes]["postal_code"]).to eq(order_attributes[:postal_code])
        expect(session[:order_attributes]["state_code"]).to eq(order_attributes[:state_code])
      end

      it "does not empty the shopping bag" do
        expect(session[:guest_shopping_bag_item][0]).to eq(product.id.to_s)
        expect(session[:guest_shopping_bag_item_qty][0]).to eq(3.to_s)
      end

      it "set error message" do
        expect(flash[:error]).to be_present
      end

      it "render template payment_new" do
        expect(response).to render_template :payment_new
      end
    end
  end

end