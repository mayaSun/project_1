require 'spec_helper'

describe SacredSymbolsController do
  describe 'GET show' do

    let(:sacred_symbol) { Fabricate(:sacred_symbol) }
    before {
      get :show, id: sacred_symbol.slug
    }

    it "set @sacred_symbol" do      
      expect(assigns(:sacred_symbol)).to be_instance_of(SacredSymbol)
    end

    it "set @products" do      
      expect(assigns(:products)).to eq([])
    end

  end
end