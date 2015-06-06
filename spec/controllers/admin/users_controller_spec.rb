require 'spec_helper'

describe Admin::UsersController do

  before do
    set_current_user(Fabricate(:admin))
  end

  describe 'GET index' do

    let(:user) { Fabricate(:user) }

    it "set @users" do      
      get :index
      expect(assigns(:users)).to include(user)
    end
  end

  describe 'PATCH update' do

    let(:user) { Fabricate(:user) }

    context "with valid input" do
      before {
        patch :update, id: user.slug ,role: 'admin'
      }

      it "update the user role" do
        expect(user.reload.role).to eq('admin')
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirect to index admin" do
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET orders' do

    let(:user) { Fabricate(:user) }

    it "set @user" do      
      get :orders, id: user.slug
      expect(assigns(:user)).to eq(user)
    end

    it "set @orders" do
      order = Fabricate(:order, user: user)      
      get :orders, id: user.slug
      expect(assigns(:orders)).to eq([order])
    end
  end
end

describe Admin::UsersController do

  let(:user) { Fabricate(:user) }

  it_behaves_like "require_admin" do
    let(:action) {get :index}
  end

  it_behaves_like "require_admin" do
    let(:action) {patch :update, id: user.slug}
  end

  it_behaves_like "require_admin" do
    let(:action) {get :orders, id: user.slug}
  end
end

