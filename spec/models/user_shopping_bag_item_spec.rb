require 'spec_helper'

describe UserShoppingBagItem do
  it {should belong_to(:position)}
  it {should belong_to(:product)}
  it {should validate_presence_of(:product)}
  it {should validate_presence_of(:position)}
  it {should validate_numericality_of(:qty)}

  it {should respond_to(:name)}
  it {should respond_to(:image)}
  it {should respond_to(:price)}

  describe "#total_price" do
    it "return the total price" do
      product = Fabricate(:product)
      user_shopping_bag_item = Fabricate(:user_shopping_bag_item, product: product)
      expect(user_shopping_bag_item.total_price).to eq(user_shopping_bag_item.qty*product.price)
    end
  end
end