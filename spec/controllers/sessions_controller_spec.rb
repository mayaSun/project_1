require 'spec_helper'

describe SessionsController do

  describe 'POST create' do

    let(:user) {Fabricate(:user)}

    context "with valid input" do
      it "set the session[id]" do
        xhr :post, :create, email: user.email, password: user.password
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "with inlavid input" do
      
      it "does not set the session[:id]" do
        xhr :post, :create, email: user.email, password: "wrongpassword"
        expect(session[:user_id]).to eq(nil)
      end
    end
  end

  describe 'GET destroy' do

    it "redirect to home page" do
      get :destroy
      expect(response).to redirect_to home_path
    end

    it "set user_id to nill" do
      get :destroy
      expect(session[:user_id]).to be_nil 
    end
  end
  
end