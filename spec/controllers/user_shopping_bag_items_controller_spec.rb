require 'spec_helper'

describe UserShoppingBagItemsController do

  before do
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  describe 'GET index' do
    context "with user" do
      it "render index" do
        set_current_user()
        get :index
        expect(response).to render_template :index
      end
    end

    context "without user" do
      it "render index" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'POST create' do
    context "with user" do
      before do
        set_current_user()
      end
      context "with valid input" do
        before do
          post :create, product_id: Fabricate(:product).id, qty: 2
        end

        it "create a user Shopping Bag item" do
          expect(UserShoppingBagItem.count).to eq(1)
        end

        it "create a user Shopping Bag item with the current_user" do
          expect(UserShoppingBagItem.first.position).to eq(current_user)
        end

        it "set notice message" do
          expect(flash[:notice]).to be_present
        end

        it "redirects back to the referring page" do
          expect(response).to redirect_to "where_i_came_from"
        end
      end

      context "with invalid input" do

        before do
          post :create, qty: 5.9
        end

        it "dose not create user Shopping Bag item" do
          expect(UserShoppingBagItem.count).to eq(0)
        end

        it "set error message" do
          expect(flash[:error]).to be_present
        end

        it "redirects back to the referring page" do
          expect(response).to redirect_to "where_i_came_from"
        end
      end
    end

    context "without user" do
      context "with valid input" do
        let(:product) { Fabricate(:product)}
        before do
          post :create, product_id: product.id, qty: 2
        end

        it "does not create a user Shopping Bag item in the db" do
          expect(UserShoppingBagItem.count).to eq(0)
        end

        it "create a user Shopping Bag item in the session veriable" do
          expect(session[:guest_shopping_bag_item][0].to_i).to eq(product.id)
          expect(session[:guest_shopping_bag_item_qty][0].to_i).to eq(2)
        end

        it "set notice message" do
          expect(flash[:notice]).to be_present
        end

        it "redirects back to the referring page" do
          expect(response).to redirect_to "where_i_came_from"
        end
      end

      context "with invalid input" do

        before do
          post :create, qty: -1
        end

        it "dose not create user Shopping Bag item in the session" do
          expect(session[:guest_shopping_bag_item].size).to eq(0)
          expect(session[:guest_shopping_bag_item_qty].size).to eq(0)
        end

        it "set error message" do
          expect(flash[:error]).to be_present
        end

        it "redirects back to the referring page" do
          expect(response).to redirect_to "where_i_came_from"
        end
      end
    end
  end

  describe 'PATCH update' do

    context "with user" do
      before do
        set_current_user()
      end

      let(:user_shopping_bag_item) {Fabricate(:user_shopping_bag_item)}

      context "with valid input" do
        before {
          patch :update, id: user_shopping_bag_item.id ,qty: 7
        }

        it "update the shopping bag item qty" do
          expect(user_shopping_bag_item.reload.qty).to eq(7)
        end

        it "set notice message" do
          expect(flash[:notice]).to be_present
        end

        it "redirects back to the referring page" do
          expect(response).to redirect_to "where_i_came_from"
        end

      end

      context "with invalid input" do

        before {
          patch :update, id: user_shopping_bag_item.id ,qty: -7
        }

        it "does not update the user shopping bag item" do
          expect(UserShoppingBagItem.first.qty).to eq(user_shopping_bag_item.qty)
        end

        it "set error message" do
          expect(flash[:error]).to be_present
        end

        it "redirects back to the referring page" do
          expect(response).to redirect_to "where_i_came_from"
        end

      end
    end

    context "without user" do

      let(:product) {Fabricate(:product)}
 
      before do
        session[:guest_shopping_bag_item] = []
        session[:guest_shopping_bag_item_qty] = []
        session[:guest_shopping_bag_item][0] = product.id.to_s
        session[:guest_shopping_bag_item_qty][0] = 2.to_s
      end

      context "with valid input" do
        before {
          patch :update, id: product.id ,qty: 7
        }

        it "update the shopping bag item qty" do
          expect(session[:guest_shopping_bag_item_qty][0].to_i).to eq(7)
        end

        it "set notice message" do
          expect(flash[:notice]).to be_present
        end

        it "redirects back to the referring page" do
          expect(response).to redirect_to "where_i_came_from"
        end

      end

      context "with invalid input" do

        before {
          patch :update, id: product.id ,qty: -7
        }

        it "does not update the user shopping bag item" do
          expect(session[:guest_shopping_bag_item_qty][0].to_i).to eq(2)
        end

        it "set error message" do
          expect(flash[:error]).to be_present
        end

        it "redirects back to the referring page" do
          expect(response).to redirect_to "where_i_came_from"
        end

      end

    end

  end


  describe 'DELETE destroy' do

    context "with user" do
      let(:user_shopping_bag_item) {Fabricate(:user_shopping_bag_item)}
      before {
        set_current_user()
        delete :destroy, id: user_shopping_bag_item.id
      }

      it "delete the user Shopping Bag items" do
        expect(UserShoppingBagItem.count).to eq(0)
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirects back to the referring page" do
        expect(response).to redirect_to "where_i_came_from"
      end
    end

    context "without user" do

      let(:product) {Fabricate(:product)}
 
      before do
        session[:guest_shopping_bag_item] = []
        session[:guest_shopping_bag_item_qty] = []
        session[:guest_shopping_bag_item][0] = product.id.to_s
        session[:guest_shopping_bag_item_qty][0] = 2.to_s
        delete :destroy, id: product.id
      end

      it "delete the user Shopping Bag items" do
        expect(session[:guest_shopping_bag_item].size).to eq(0)
        expect(session[:guest_shopping_bag_item_qty].size).to eq(0)
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirects back to the referring page" do
        expect(response).to redirect_to "where_i_came_from"
      end

    end

  end

end