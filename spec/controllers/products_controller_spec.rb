require 'spec_helper'

describe ProductsController do
  describe 'GET show' do
    let(:product) { Fabricate(:product) }
    before {
      get :show, id: product.slug
    }

    it "set @product" do      
      expect(assigns(:product)).to be_instance_of(Product)
    end

    it "set @products" do      
      expect(assigns(:related_products)).to eq([product])
    end
  end

  describe "GET search" do
    it "set the @products objects" do
      maya = Fabricate(:product, name: 'maya')
      get :search, search_term: 'm'
      expect(assigns(:products)).to eq([maya])
    end
  end
end