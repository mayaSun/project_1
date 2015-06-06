require 'spec_helper'

describe Admin::CategoriesController do

  before do
    set_current_user(Fabricate(:admin))
  end

  describe 'GET index' do

    before do
      get :index
    end

    it "set @category" do      
      expect(assigns(:category)).to be_instance_of(Category)
    end

    it "set @categories" do      
      expect(assigns(:categories)).to eq([])
    end
  end

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

  describe 'POST create' do

    context "with valid input" do

      before do
        post :create, category: Fabricate.attributes_for(:category)
      end

      it "create a category" do
        expect(Category.count).to eq(1)
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirect to index admin" do
        expect(response).to redirect_to admin_categories_path
      end

    end

    context "with invalid input" do

      before do
        post :create, category: Fabricate.attributes_for(:category, name: nil)
      end

      it "dose not create category" do
        expect(Category.count).to eq(0)
      end

      it "set error message" do
        expect(flash[:error]).to be_present
      end

      it "render :index" do
        expect(response).to render_template :index
      end 

      it "set @category" do
        expect(assigns(:category)).to be_instance_of(Category)
      end

      it "set @categories" do
        expect(assigns(:categories)).to eq([])
      end
    end
  end

  describe 'GET edit' do

    let(:category) {Fabricate(:category)}
    before {
      get :edit , id: category.slug
    }

    it "set the @product veriable" do        
      expect(assigns[:category]).to eq(category)
    end

    it "set the @products veriable" do        
      expect(assigns[:categories]).to eq([category])
    end

    it "render the index template" do        
      expect(response).to render_template :index
    end
  end

  describe 'PATCH update' do

    let(:category) { Fabricate(:category) }

    context "with valid input" do
      before {
        patch :update, id: category.slug ,category: {name: 'New name'}
      }

      it "update the category name" do
        expect(category.reload.name).to eq('New Name')
      end

      it "set notice message" do
        expect(flash[:notice]).to be_present
      end

      it "redirect to index admin" do
        expect(response).to redirect_to admin_categories_path
      end

    end

    context "with invalid input" do

      before {
        patch :update, id: category.slug, category: {name: nil}
      }

      it "does not update the category" do
        expect(Category.first.attributes).to eq(category.attributes)
      end

      it "set the @category veriable" do        
        expect(assigns[:category]).to eq(category)
      end

      it "set the @categories veriable" do        
        expect(assigns[:categories]).to eq([category])
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

    let(:category) {Fabricate(:category)}
    before {
      delete :destroy, id: category.slug
    }

    it "delete the category" do
      expect(Category.count).to eq(0)
    end

    it "redirect to index admin" do
      expect(response).to redirect_to admin_categories_path
    end

    it "set notice message" do
      expect(flash[:notice]).to be_present
    end
  end
end


describe Admin::CategoriesController do

  let(:category) {Fabricate(:category)}

  it_behaves_like "require_admin" do
    let(:action) { get :index}
  end

  it_behaves_like "require_admin" do
    let(:action) { get :index, id: category.slug}
  end

  it_behaves_like "require_admin" do
    let(:action) { post :create, category: Fabricate.attributes_for(:category)}
  end

  it_behaves_like "require_admin" do
    let(:action) { get :edit , id: category.slug}
  end

  it_behaves_like "require_admin" do
    let(:action) { patch :update, id: category.slug }
  end

  it_behaves_like "require_admin" do
    let(:action) { delete :destroy, id: category.slug}
  end

end