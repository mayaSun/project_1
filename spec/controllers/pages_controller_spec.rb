require 'spec_helper'

describe PagesController do
  describe 'GET home' do
    it "set new_products" do
      get :home
      expect(assigns(:new_products)).to eq([])
    end
    it "set best sellers" do
      get :home
      expect(assigns(:best_sellers)).to eq([])
    end
  end

  describe 'GET my_account' do
    it_behaves_like "require_user" do
      let(:action) { get :my_account}
    end
  end

  describe 'GET my_orders' do
    it_behaves_like "require_user" do
      let(:action) { get :my_account}
    end
  end

end