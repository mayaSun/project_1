require 'spec_helper'

describe Product do 

  it {should belong_to(:category)}
  it {should have_many(:sacred_symbols)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:price)}
  it {should validate_presence_of(:category)}
  it {should validate_presence_of(:image)}
  it {should validate_numericality_of(:stock)}
  it {should validate_numericality_of(:price)}

  it {should have_many(:wishlisted_users)}


  describe "search product by name" do
    let(:mayami)  { Fabricate(:product, name: "Mayami")}
    let(:kalidaso)  { Fabricate(:product,name: "Kalidaso")}

    it "return array of  all the product with a given name" do
      expect(Product.search_by_name("Mayami")).to eq([mayami])
    end

    it "return array of  all the products with a partial match" do
      expect(Product.search_by_name("a")).to include(mayami)
      expect(Product.search_by_name("a")).to include(kalidaso)
      expect(Product.search_by_name("a").size).to eq(2)
    end

    it "return empty string when dosn't find products with given name" do
      expect(Product.search_by_name("q").size).to eq(0)
    end

    it "return array string when search_term is empty string" do
      expect(Product.search_by_name("")).to eq([])
    end
  end

  describe "#orders" do
    it "return the orders contained the product" do
      product = Fabricate(:product)
      other_product = Fabricate(:product)
      order1 = UserShoppingBagItem.create(product: product, position: Fabricate(:order), qty: 1)
      order2 = UserShoppingBagItem.create(product: other_product, position: Fabricate(:order), qty: 1)
      order3 = UserShoppingBagItem.create(product: product, position: Fabricate(:order), qty: 1)
      expect(product.orders.count).to eq(2)
      expect(product.orders).to include(order1)
      expect(product.orders).to include(order3)
      expect(product.orders).to_not include(order2)
    end

    it "return [] if there is no orders" do
      product = Fabricate(:product)
      other_product = Fabricate(:product)
      UserShoppingBagItem.create(product: other_product, position: Fabricate(:order), qty: 1)
      expect(product.orders).to eq([])
    end
  end

  describe "#last_ordered" do
    it "return the last order date of the product" do
      product = Fabricate(:product)
      other_product = Fabricate(:product)
      order1 = UserShoppingBagItem.create(product: product, position: Fabricate(:order), qty: 1, updated_at: 1.days.ago)
      order2 = UserShoppingBagItem.create(product: other_product, position: Fabricate(:order), qty: 1)
      order3 = UserShoppingBagItem.create(product: product, position: Fabricate(:order), qty: 1, updated_at: 3.days.ago)
      expect(product.last_ordered.to_formatted_s(:short) ).to eq(order1.updated_at.to_formatted_s(:short))
    end
  end

  it_behaves_like "slugable" do
    let(:object) { Fabricate(:category) }
  end

end