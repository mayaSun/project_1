require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it "set the @user veriable" do
      xhr :get, :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do

    context "with valid input" do

      let(:user_attributes) {Fabricate.attributes_for(:user)}
      
      it "set the @user veriable" do
        xhr :post, :create, user: user_attributes
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "save @user veriable" do
        xhr :post, :create, user: user_attributes
        expect(User.count).to eq(1)
        expect(User.first.name).to eq(user_attributes[:name])
        expect(User.first.email).to eq(user_attributes[:email])
        expect(User.first.authenticate(user_attributes[:password])).to be_instance_of(User)
      end

      it "set session[:user_id]" do
        xhr :post, :create, user: user_attributes
        expect(session[:user_id]).to eq(User.first.id)
      end

      context "with shopping_bag items veriable" do

        let(:product1) { Fabricate(:product)}
        let(:product2) { Fabricate(:product)}

        before do
          session[:guest_shopping_bag_item] = []
          session[:guest_shopping_bag_item_qty] = []
          session[:guest_shopping_bag_item][0] = product1.id.to_s
          session[:guest_shopping_bag_item_qty][0] = 7.to_s
          session[:guest_shopping_bag_item][1] = product2.id.to_s
          session[:guest_shopping_bag_item_qty][1] = 6.to_s
          session[:guest_wishlist_item] = []
          session[:guest_wishlist_item][0] = product1.id.to_s
          session[:guest_wishlist_item][1] = product2.id.to_s
          xhr :post, :create, user: user_attributes
        end

        it "set the user shopping_bag veriable" do
          expect(User.first.user_shopping_bag_items.count).to eq(2)
          expect(User.first.shopping_bag_items).to include(product1)
          expect(User.first.shopping_bag_items).to include(product2)
        end

        it "set the user wishlist veriable" do
          expect(User.first.user_wishlist_items.count).to eq(2)
          expect(User.first.wishlist_items).to include(product1)
          expect(User.first.wishlist_items).to include(product2)
        end
      end
    end
  end

  describe 'PATCH update' do

    let(:user) {Fabricate(:user, name: 'bibi', password: 'oldpassword')}
    
    before do
      set_current_user(user)
    end

    context "password reset" do
      
      context "with valid input" do

        before do
          patch :update, id: user.slug, user: {password: "newpassword"}, password_authentication: user.password, commit: 'Reset Password'
        end

        it "reset the password" do
          expect(User.first.authenticate("newpassword")).to be_instance_of(User)
        end

        it "doe's not change other attributes" do
          expect(User.first.name).to eq('bibi')
        end
        
        it "set notice message" do
          expect(flash[:notice]).to be_present
        end

        it "set the @user veriable" do        
          expect(assigns(:user)).to be_instance_of(User)
        end
        
        it "render my_account" do
          expect(response).to render_template 'pages/my_account'
        end
      end

      context "with invalid input" do
        
        before do
          patch :update, id: user.slug, user: {password: "newpassword", password_confirmation: "mewpassword"}, password_authentication: user.password
        end

        it "does not reset the password" do
          expect(User.first.authenticate("oldpassword")).to be_instance_of(User)  
        end
        
        it "set error message" do
          expect(flash[:error]).to be_present
        end
        
        it "set the @user veriable" do        
          expect(assigns(:user)).to be_instance_of(User)
        end
        
        it "render my_account" do
          expect(response).to render_template 'pages/my_account'
        end
      end


      context "with invalid old password" do
        
        before do
          patch :update, id: user.slug, user: {password: "newpassword", password_confirmation: "newpassword"}, password_authentication: 'goldpassword'
        end

        it "does not reset the password" do
          expect(User.first.authenticate("oldpassword")).to be_instance_of(User)  
        end
        
        it "set error message" do
          expect(flash[:error]).to be_present
        end
        
        it "set the @user veriable" do        
          expect(assigns(:user)).to be_instance_of(User)
        end
        
        it "render my_account" do
          expect(response).to render_template 'pages/my_account'
        end
      end

    end

    context "update details" do
      
      context "with valid input" do

        before do
          patch :update, id: user.slug, user: {name: "lapid", email: user.email}, data_authentication: user.password, commit: 'Update'
        end

        it "update user" do
          expect(User.first.name).to eq("lapid")  
        end

        it "doe's not change other attributes" do
          expect(User.first.email).to eq(user.email)
          expect(User.first.authenticate("oldpassword")).to be_instance_of(User)
        end

        it "set notice message" do
          expect(flash[:notice]).to be_present
        end

        it "set the @user veriable" do        
          expect(assigns(:user)).to be_instance_of(User)
        end
        
        it "render my_account" do
          expect(response).to render_template 'pages/my_account'
        end
      end

      context "with invalid input" do

        before do
          patch :update, id: user.slug, user: {name: "lapid", email: nil}, data_authentication: user.password
        end

        it "does not update the user" do
          expect(User.first.name).to eq('bibi')
          expect(User.first.email).to eq(user.email)
        end

        it "set error message" do
          expect(flash[:error]).to be_present
        end
        
        it "set the @user veriable" do        
          expect(assigns(:user)).to be_instance_of(User)
        end
        
        it "render my_account" do
          expect(response).to render_template 'pages/my_account'
        end
      end

      context "with invalid password" do

        before do
          patch :update, id: user.slug, user: {name: "lapid", email: user.email}, data_authentication: 'goldpassword'
        end

        it "does not update the user" do
          expect(User.first.name).to eq('bibi')
          expect(User.first.email).to eq(user.email)
        end

        it "set error message" do
          expect(flash[:error]).to be_present
        end
        
        it "set the @user veriable" do        
          expect(assigns(:user)).to be_instance_of(User)
        end
        
        it "render my_account" do
          expect(response).to render_template 'pages/my_account'
        end
      end

    end

    it "require user is current_user" do
      set_current_user()
      patch :update, id: user.slug, user: {name: "lapid", email: user.email}, data_authentication: user.password
      expect(response).to redirect_to home_path
    end

  end

end