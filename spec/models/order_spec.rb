require 'spec_helper'

describe Order do

  it { should validate_presence_of(:first_name)}
  it { should validate_presence_of(:last_name)}
  it { should validate_presence_of(:address_line1)}
  it { should validate_presence_of(:city)}
  it { should validate_presence_of(:country_code)}
  it { should validate_presence_of(:phone_number)}
  it { should validate_presence_of(:postal_code)}
  it { should validate_presence_of(:email)}
  it {should have_many(:shopping_bag_items)}
  it {should belong_to(:user)}


  describe '#slug_column' do
    it "set the slug column" do
      Fabricate(:order, first_name: 'muy', last_name: 'hikop')
      expect(Order.first.slug_column).to eq('muyhikop')
    end  
  end

  describe '#total_bill' do

    it 'set the total bill' do
      order = Fabricate(:order)
      product1 = Fabricate(:product)
      product2 = Fabricate(:product)
      UserShoppingBagItem.create(position: order, product: product1, qty: 7)
      UserShoppingBagItem.create(position: order, product: product2, qty: 3)
      expect(order.total_bill).to eq(product1.price*7 + product2.price*3)
    end
  end

  describe '#update_stock' do
    it "update the stock" do
      order = Fabricate(:order)
      product1 = Fabricate(:product, stock: 7)
      product2 = Fabricate(:product, stock: 70)
      UserShoppingBagItem.create(position: order, product: product1, qty: 7)
      UserShoppingBagItem.create(position: order, product: product2, qty: 3)
      order.update_stock
      expect(product1.reload.stock).to eq(0)
      expect(product2.reload.stock).to eq(67)
    end  
  end

  describe '#last_orders' do
    it "set the last order in the right order" do
      order3 = Fabricate(:order, status: 'paid', updated_at: 3.days.ago)
      order2 = Fabricate(:order, status: 'sent', updated_at: 2.days.ago)
      order0 = Fabricate(:order, status: 'sent', updated_at: 0.days.ago)
      order1 = Fabricate(:order, status: 'paid', updated_at: 1.days.ago)
      expect(Order.last_orders).to eq([order3, order1, order0, order2])

    end
  end

  it_behaves_like "slugable" do
    let(:object) { Fabricate(:category) }
  end

end