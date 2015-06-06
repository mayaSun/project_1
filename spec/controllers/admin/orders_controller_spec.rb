require 'spec_helper'

describe Admin::OrdersController do

  before do
    set_current_user(Fabricate(:admin))
  end

  describe 'GET index' do

    before do
      get :index
    end

    it "set @orders" do      
      expect(assigns(:orders)).to eq([])
    end

  end


  describe 'GET edit' do

    let(:order) {Fabricate(:order)}
    before {
      get :edit , id: order.slug
    }

    it "set the @order veriable" do        
      expect(assigns[:order]).to eq(order)
    end

  end

  describe 'PATCH update' do

    let(:order) { Fabricate(:order) }

    context "with valid input" do
      before {
        patch :update, id: order.slug ,confirmation_number: '1234', tracking_number: '5678'
      }

      it "update the order attributes" do
        expect(order.reload.confirmation_number).to eq('1234')
        expect(order.reload.tracking_number).to eq('5678')
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirect to index admin" do
        expect(response).to redirect_to admin_orders_path
      end
    end
  end

end

describe Admin::OrdersController do

  it_behaves_like "require_admin" do
    let(:action) { get :index}
  end

  it_behaves_like "require_admin" do
    let(:order) {Fabricate(:order)}
    let(:action) { get :edit , id: order.slug}
  end

  it_behaves_like "require_admin" do
    let(:order) {Fabricate(:order)}
    let(:action) { patch :update, id: order.slug ,confirmation_number: '1234', tracking_number: '5678'}
  end

end