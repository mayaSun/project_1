require 'spec_helper'

describe Admin::SacredSymbolsController do

  before do
    set_current_user(Fabricate(:admin))
  end

  describe 'GET index' do

    it "set @sacred_symbol" do      
      get :index
      expect(assigns(:sacred_symbol)).to be_instance_of(SacredSymbol)
    end

    it "set @sacred_symbols" do      
      get :index
      expect(assigns(:sacred_symbols)).to eq([])
    end

  end

  describe 'POST create' do

    context "with valid input" do

      before do
        post :create, sacred_symbol: Fabricate.attributes_for(:sacred_symbol)
      end

      it "create a sacred_symbol" do
        expect(SacredSymbol.count).to eq(1)
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirect to index admin" do
        expect(response).to redirect_to admin_sacred_symbols_path
      end

    end

    context "with invalid input" do

      before do
        post :create, sacred_symbol: Fabricate.attributes_for(:sacred_symbol, name: nil)
      end

      it "dose not create sacred_symbol" do
        expect(SacredSymbol.count).to eq(0)
      end

      it "set error message" do
        expect(flash[:error]).to be_present
      end

      it "render :index" do
        expect(response).to render_template :index
      end 

      it "set @sacred_symbol" do
        expect(assigns(:sacred_symbol)).to be_instance_of(SacredSymbol)
      end

      it "set @sacred_symbols" do
        expect(assigns(:sacred_symbols)).to eq([])
      end
    end

  end

  describe 'GET edit' do

    let(:sacred_symbol) {Fabricate(:sacred_symbol)}
    before {
      get :edit , id: sacred_symbol.slug
    }

    it "set the @sacred_symbol veriable" do        
      expect(assigns[:sacred_symbol]).to eq(sacred_symbol)
    end

    it "set the @sacred_symbols veriable" do        
      expect(assigns[:sacred_symbols]).to eq([sacred_symbol])
    end

    it "render the index template" do        
      expect(response).to render_template :index
    end
  end

  describe 'PATCH update' do

    let(:sacred_symbol) { Fabricate(:sacred_symbol) }

    context "with valid input" do
      before {
        patch :update, id: sacred_symbol.slug ,sacred_symbol: {name: 'New name'}
      }

      it "update the sacred_symbol name" do
        expect(sacred_symbol.reload.name).to eq('New Name')
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirect to index admin" do
        expect(response).to redirect_to admin_sacred_symbols_path
      end

    end

    context "with invalid input" do

      before {
        patch :update, id: sacred_symbol.slug, sacred_symbol: {name: nil}
      }

      it "does not update the sacred_symbol" do
        expect(SacredSymbol.first.attributes).to eq(sacred_symbol.attributes)
      end

      it "set the @sacred_symbol veriable" do        
        expect(assigns[:sacred_symbol]).to eq(sacred_symbol)
      end

      it "set the @sacred_symbols veriable" do        
        expect(assigns[:sacred_symbols]).to eq([sacred_symbol])
      end

      it "render index" do
        expect(response).to render_template :index
      end

      it "set error message" do
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'DELETE destroy' do

    let(:sacred_symbol) {Fabricate(:sacred_symbol)}
    before {
      delete :destroy, id: sacred_symbol.slug
    }

    it "delete the sacred_symbol" do
      expect(SacredSymbol.count).to eq(0)
    end

    it "redirect to index admin" do
      expect(response).to redirect_to admin_sacred_symbols_path
    end

    it "set notice message" do
      expect(flash[:notice]).to be_present
    end
  end
end

describe Admin::SacredSymbolsController do

  let(:sacred_symbol) {Fabricate(:sacred_symbol)}

  it_behaves_like "require_admin" do
    let(:action) {get :index}
  end

  it_behaves_like "require_admin" do
    let(:action) {post :create, sacred_symbol: Fabricate.attributes_for(:sacred_symbol)}
  end

  it_behaves_like "require_admin" do
    let(:action) {get :edit , id: sacred_symbol.slug}
  end

  it_behaves_like "require_admin" do
    let(:action) {patch :update, id: sacred_symbol.slug}
  end

  it_behaves_like "require_admin" do
    let(:action) {delete :destroy, id: sacred_symbol.slug}
  end
end