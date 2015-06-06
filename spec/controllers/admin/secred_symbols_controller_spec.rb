require 'spec_helper'

describe Admin::SecredSymbolsController do

  before do
    set_current_user(Fabricate(:admin))
  end

  describe 'GET index' do

    it "set @secred_symbol" do      
      get :index
      expect(assigns(:secred_symbol)).to be_instance_of(SecredSymbol)
    end

    it "set @secred_symbols" do      
      get :index
      expect(assigns(:secred_symbols)).to eq([])
    end

    it_behaves_like "require_admin" do
      let(:action) {get :index}
    end

  end

  describe 'POST create' do

    context "with valid input" do

      before do
        post :create, secred_symbol: Fabricate.attributes_for(:secred_symbol)
      end

      it "create a secred_symbol" do
        expect(SecredSymbol.count).to eq(1)
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirect to index admin" do
        expect(response).to redirect_to admin_secred_symbols_path
      end

    end

    context "with invalid input" do

      before do
        post :create, secred_symbol: Fabricate.attributes_for(:secred_symbol, name: nil)
      end

      it "dose not create secred_symbol" do
        expect(SecredSymbol.count).to eq(0)
      end

      it "set error message" do
        expect(flash[:error]).to be_present
      end

      it "render :index" do
        expect(response).to render_template :index
      end 

      it "set @secred_symbol" do
        expect(assigns(:secred_symbol)).to be_instance_of(SecredSymbol)
      end

      it "set @secred_symbols" do
        expect(assigns(:secred_symbols)).to eq([])
      end
    end

    it_behaves_like "require_admin" do
      let(:action) {post :create, secred_symbol: Fabricate.attributes_for(:secred_symbol)}
    end

  end

  describe 'GET edit' do

    let(:secred_symbol) {Fabricate(:secred_symbol)}
    before {
      get :edit , id: secred_symbol.slug
    }

    it "set the @secred_symbol veriable" do        
      expect(assigns[:secred_symbol]).to eq(secred_symbol)
    end

    it "set the @secred_symbols veriable" do        
      expect(assigns[:secred_symbols]).to eq([secred_symbol])
    end

    it "render the index template" do        
      expect(response).to render_template :index
    end

    it_behaves_like "require_admin" do
      let(:action) {get :edit , id: secred_symbol.slug}
    end

  end

  describe 'PATCH update' do

    let(:secred_symbol) { Fabricate(:secred_symbol) }

    context "with valid input" do
      before {
        patch :update, id: secred_symbol.slug ,secred_symbol: {name: 'New name'}
      }

      it "update the secred_symbol name" do
        expect(secred_symbol.reload.name).to eq('New name')
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirect to index admin" do
        expect(response).to redirect_to admin_secred_symbols_path
      end

    end

    context "with invalid input" do

      before {
        patch :update, id: secred_symbol.slug, secred_symbol: {name: nil}
      }

      it "does not update the secred_symbol" do
        expect(SecredSymbol.first.attributes).to eq(secred_symbol.attributes)
      end

      it "set the @secred_symbol veriable" do        
        expect(assigns[:secred_symbol]).to eq(secred_symbol)
      end

      it "set the @secred_symbols veriable" do        
        expect(assigns[:secred_symbols]).to eq([secred_symbol])
      end

      it "render index" do
        expect(response).to render_template :index
      end

      it "set error message" do
        expect(flash[:error]).to be_present
      end
    end

    it_behaves_like "require_admin" do
      let(:action) {patch :update, id: secred_symbol.slug}
    end

  end

  describe 'DELETE destroy' do

    let(:secred_symbol) {Fabricate(:secred_symbol)}
    before {
      delete :destroy, id: secred_symbol.slug
    }

    it "delete the secred_symbol" do
      expect(SecredSymbol.count).to eq(0)
    end

    it "redirect to index admin" do
      expect(response).to redirect_to admin_secred_symbols_path
    end

    it "set notice message" do
      expect(flash[:notice]).to be_present
    end

    it_behaves_like "require_admin" do
      let(:action) {delete :destroy, id: secred_symbol.slug}
    end
  end
end