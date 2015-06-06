require 'spec_helper'

describe GuestShoppingBag do

  let(:product) {Fabricate(:product)} 
  let(:shopping_bag_item) {GuestShoppingBag.new(product_id: product.id, qty: 7)}

  it "response to product_id" do
    expect(shopping_bag_item.product_id).to eq(product.id)
  end

  it "response to qty" do
    expect(shopping_bag_item.qty).to eq(7)
  end

  it "response to product" do
    expect(shopping_bag_item.product).to eq(product)
  end

  it "response to name" do
    expect(shopping_bag_item.name).to eq(product.name)
  end

  it "response to id" do
    expect(shopping_bag_item.id).to eq(product.id)
  end

  it "response to price" do
    expect(shopping_bag_item.price).to eq(product.price)
  end

  it "response to total price" do
    expect(shopping_bag_item.total_price).to eq(7*shopping_bag_item.price)
  end

  describe "#params_validated?" do
    it "return true for valid qty" do
      expect(GuestShoppingBag.params_validated?(qty: 4)).to eq(true)
    end
    it "return false for invalid qty" do
      expect(GuestShoppingBag.params_validated?(qty: -4)).to eq(false)
    end
  end

end