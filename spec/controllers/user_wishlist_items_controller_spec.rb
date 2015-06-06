require 'spec_helper'

describe UserWishlistItemsController do

  before do
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  describe 'GET index' do

    context "with user" do
      it "set the @wishlist veriable" do
        set_current_user()
        get :index
        expect(assigns(:wishlist)).to eq([])
      end
    end

    context "without user" do
      it "set the @wishlist veriable" do
        get :index
        expect(assigns(:wishlist)).to eq([])
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
          post :create, product_id: Fabricate(:product).id
        end

        it "create a user wishlist item" do
          expect(UserWishlistItem.count).to eq(1)
        end

        it "create a user wishlist item with the current_user" do
          expect(UserWishlistItem.first.user).to eq(current_user)
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
          post :create, product_id: nil
        end

        it "dose not create user wishlist item" do
          expect(UserWishlistItem.count).to eq(0)
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
        post :create, product_id: product.id
      end

      it "does not create a user wishlist item in the db" do
        expect(UserWishlistItem.count).to eq(0)
      end

      it "create a user wishlist item in the session" do
        expect(session[:guest_wishlist_item][0].to_i).to eq(product.id)
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirects back to the referring page" do
        expect(response).to redirect_to "where_i_came_from"
      end
    end
  end

  describe 'DELETE destroy' do

    context "with user" do
      before do
        set_current_user()
      end
      context "without add to bag" do
        let(:user_wishlist_item) {Fabricate(:user_wishlist_item)}
        before {
          delete :destroy, id: user_wishlist_item.id
        }

        it "delete the user wishlist items" do
          expect(UserWishlistItem.count).to eq(0)
        end

        it "set notice message" do
          expect(flash[:notice]).to be_present
        end

        it "redirects back to the referring page" do
          expect(response).to redirect_to "where_i_came_from"
        end
      end

      context "with add to bag" do
        let(:user_wishlist_item) {Fabricate(:user_wishlist_item)}
        before {
          delete :destroy, id: user_wishlist_item.id, add_to_bag: true
        }

        it "delete the user wishlist items" do
          expect(UserWishlistItem.count).to eq(0)
        end

        it "create user shopping bag items" do
          expect(UserShoppingBagItem.count).to eq(1)
        end

        it "create user shopping bag items with current user" do
          expect(UserShoppingBagItem.first.position).to eq(current_user)
        end

        it "set notice message" do
          expect(flash[:notice]).to be_present
        end

        it "redirects back to the referring page" do
          expect(response).to redirect_to "where_i_came_from"
        end
      end
    end

    context "without user" do

      let(:product) {Fabricate(:product)}
      before do
        session[:guest_wishlist_item] = []
        session[:guest_wishlist_item][0] = product.id.to_s 
      end
      context "without add to bag" do

        before do
          delete :destroy, id: product.id
        end

        it "delete the user wishlist items" do
          expect(session[:guest_wishlist_item].size).to eq(0)
        end

        it "set notice message" do
          expect(flash[:notice]).to be_present
        end

        it "redirects back to the refering page" do
          expect(response).to redirect_to "where_i_came_from"
        end
      end

      context "with add to bag" do
        before {
          delete :destroy, id: product.id, add_to_bag: true
        }

        it "delete the user wishlist items" do
          expect(session[:guest_wishlist_item].size).to eq(0)
        end

        it "does not create user shopping bag items in the db" do
          expect(UserShoppingBagItem.count).to eq(0)
        end

        it "create user shopping bag items in the session" do
          expect(session[:guest_shopping_bag_item][0].to_i).to eq(product.id)
          expect(session[:guest_shopping_bag_item_qty][0].to_i).to eq(1)
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
end