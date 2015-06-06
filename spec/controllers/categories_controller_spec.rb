require 'spec_helper'

describe CategoriesController do
  describe 'GET show' do

    let(:category) { Fabricate(:category) }
    before {
      get :show, id: category.slug
    }

    it "set @category" do      
      expect(assigns(:category)).to be_instance_of(Category)
    end

    it "set @products" do      
      expect(assigns(:products)).to eq([])
    end

  end
end