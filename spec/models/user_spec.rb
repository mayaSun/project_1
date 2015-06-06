require 'spec_helper'

describe User do

  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:password)}
  it {should have_many(:user_shopping_bag_items)}
  it {should have_many(:shopping_bag_items)}
  it {should have_many(:wishlist_items)}
  it {should have_many(:user_wishlist_items)}
  it {should have_many(:orders)}

  it 'set the role by default to customer' do
    user = User.create(name: 'Maya', email:'maya@gmail.com', password: 'mayale')
    expect(user.role).to eq('customer')
  end

  describe "#set_user_name" do
    it "set the name to user without name input" do
      sara = User.create(email: "sara@mitmail.com", password: "123")
      expect(sara.name).to eq("sara")
    end
  end

  describe "#total_bill" do
    it "return the total bill" do
      user = Fabricate(:user)
      product1 = Fabricate(:product)
      product2 = Fabricate(:product)
      UserShoppingBagItem.create(position: user, product: product1, qty: 7)
      UserShoppingBagItem.create(position: user, product: product2, qty: 1)
      expect(user.total_bill).to eq(7*product1.price + product2.price)
    end
  end

  it_behaves_like "slugable" do
    let(:object) { Fabricate(:category) }
  end
  
end