require 'spec_helper'

feature 'User Fill Shopping Bag And Wishlist' do

  given(:flower_of_life) { Fabricate(:sacred_symbol) }
  given(:merkaba) { Fabricate(:sacred_symbol) }
  
  given(:brass) { Fabricate(:category) }
  given(:silver) { Fabricate(:category) }

  given!(:green_merkaba) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id]) }
  given!(:gold_merkaba_flower_of_life) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id, flower_of_life.id]) }  
  given!(:gold_flower_of_life) { Fabricate(:product, category: silver, sacred_symbol_ids: [flower_of_life.id]) }  
  given!(:gold_merkaba) { Fabricate(:product, category: silver, sacred_symbol_ids: [merkaba.id]) }  
  given!(:blue_merkaba) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id], stock: 50, price: 1000)}
  given!(:green_merkaba_flower_of_life) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id, flower_of_life.id], stock: 50, price: 1000) }  
  given!(:green_flower_of_life) { Fabricate(:product, category: silver, sacred_symbol_ids: [flower_of_life.id]) }  
  given!(:blue_flower_of_life) { Fabricate(:product, category: silver, sacred_symbol_ids: [merkaba.id]) } 
  given!(:blue_gold_merkaba) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id]) }
  given!(:blue_merkaba_flower_of_life) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id, flower_of_life.id]) }  
  given!(:red_merkaba) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id]) }
  given!(:red_merkaba_flower_of_life) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id, flower_of_life.id]) }  
  given!(:red_flower_of_life) { Fabricate(:product, category: silver, sacred_symbol_ids: [flower_of_life.id]) }  
  given!(:yellow_merkaba) { Fabricate(:product, category: silver, sacred_symbol_ids: [merkaba.id]) }  
  given!(:silver_merkaba) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id]) }
  given!(:yellow_merkaba_flower_of_life) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id, flower_of_life.id]) }  
  given!(:yellow_flower_of_life) { Fabricate(:product, category: silver, sacred_symbol_ids: [flower_of_life.id]) }  
  given!(:silver_flower_of_life) { Fabricate(:product, category: silver, sacred_symbol_ids: [merkaba.id]) } 
  given!(:silver_gold_merkaba) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id]) }
  given!(:silver_merkaba_flower_of_life) { Fabricate(:product, category: brass, sacred_symbol_ids: [merkaba.id, flower_of_life.id]) }  
 

  scenario "guest user fill shopping bag and wishlist" do
    user_adds_products_to_shopping_bag
  end

  scenario "user fill shopping bag and wishlist" do
    user = Fabricate(:user)
    page.set_rack_session(user_id: user.id)
    user_adds_products_to_shopping_bag
    validate_shopping_bag_and_wishlist_summary
  end

  def user_adds_products_to_shopping_bag 
    # Home page
    visit home_path
    add_product_from_list_to_shopping_bag(green_merkaba)
    add_product_from_list_to_wishlist(silver_merkaba)
    expect_product_to_be_in_shopping_bag(green_merkaba)
    expect_product_to_be_in_wishlist(silver_merkaba)    
    
    # Category page
    click_link brass.name
    expect_to_see_category_products(brass)
    add_product_from_list_to_shopping_bag(silver_gold_merkaba)
    add_product_from_list_to_wishlist(silver_merkaba_flower_of_life)
    expect_product_to_be_in_shopping_bag(silver_gold_merkaba)
    expect_product_to_be_in_wishlist(silver_merkaba_flower_of_life)
    
    # Sacred Symbol page
    click_link merkaba.name
    expect_to_see_sacred_symbol_products(merkaba)
    add_product_from_list_to_shopping_bag(red_merkaba_flower_of_life)
    add_product_from_list_to_wishlist(yellow_merkaba)
    expect_product_to_be_in_shopping_bag(red_merkaba_flower_of_life)
    expect_product_to_be_in_wishlist(yellow_merkaba) 
    
    # Product Page
    click_link merkaba.name
    add_product_from_product_page_to_shopping_bag(blue_gold_merkaba)
    expect_product_to_be_in_shopping_bag(blue_gold_merkaba)

    click_link merkaba.name
    add_product_from_product_page_to_shopping_bag(blue_merkaba, 7)
    expect_product_to_be_in_shopping_bag(blue_merkaba, 7)
    
    click_link flower_of_life.name
    add_product_from_product_page_to_wishlist(yellow_merkaba_flower_of_life)
    expect_product_to_be_in_wishlist(yellow_merkaba_flower_of_life)
    
    # Wishlist
    add_product_from_wishlist_to_shopping_bag(yellow_merkaba_flower_of_life)
    expect_product_to_be_in_shopping_bag(yellow_merkaba_flower_of_life)
    expect_product_not_to_be_in_wishlist(yellow_merkaba_flower_of_life)
    
    delete_product_from_wishlist(yellow_merkaba)
    expect_product_not_to_be_in_shopping_bag(yellow_merkaba)
    expect_product_not_to_be_in_wishlist(yellow_merkaba)
  
    # Shopping Bag
    find('.dropdown-toggle-shopping-bag').click
    click_link "View Bag"
    update_qty_of_shopping_bag_product(green_merkaba, 8)
    expect_product_to_be_in_shopping_bag(green_merkaba, 8)
    delete_product_from_shopping_bag(silver_gold_merkaba)
    expect_product_not_to_be_in_shopping_bag(silver_gold_merkaba)

    # Summary
    validate_shopping_bag_and_wishlist_summary
  
  end

  def validate_shopping_bag_and_wishlist_summary
    expect_product_to_be_in_shopping_bag(green_merkaba, 8)
    expect_product_to_be_in_shopping_bag(red_merkaba_flower_of_life)
    expect_product_to_be_in_shopping_bag(blue_gold_merkaba)
    expect_product_to_be_in_shopping_bag(blue_merkaba, 7)
    expect_product_to_be_in_shopping_bag(yellow_merkaba_flower_of_life)

    expect_product_to_be_in_wishlist(silver_merkaba)
    expect_product_to_be_in_wishlist(silver_merkaba_flower_of_life) 
  end

  def add_product_from_list_to_shopping_bag(product)
    find("a[href='/user_shopping_bag_items?product_id=#{product.id}&qty=1']").click
  end

  def add_product_from_list_to_wishlist(product)
    find("a[href='/user_wishlist_items?product_id=#{product.id}']").click
  end

  def expect_product_to_be_in_shopping_bag(product, qty=1)
    click_link "View Bag"
    shopping_bag = find('.shopping-bag-table')
    tr = shopping_bag.find('tr', text: product.name)
    expect(tr).to have_content product.name
    expect(tr).to have_content (product.price/100)
    expect(tr.find_field('qty').value).to eq (qty.to_s)
    expect(tr).to have_content (product.price*qty/100)
  end

  def expect_product_to_be_in_wishlist(product)
    find("a[href='/wishlist']").click
    wishlist = find('.shopping-bag-table')
    expect(wishlist).to have_content product.name
    expect(wishlist).to have_content (product.price/100)
  end

  def add_product_from_product_page_to_shopping_bag(product, qty=1)
    find(:xpath, "(//a[@href='/products/#{product.slug}'])[1]").click
    form = find('.product-info')
    fill_in "QTY", with: qty
    form.click_button("Add To Bag")
  end

  def add_product_from_product_page_to_wishlist(product)
    find(:xpath, "(//a[@href='/products/#{product.slug}'])[1]").click
    form = find('.product-info')
    form.find('.btn-wishlist').click
  end  

  def expect_to_see_category_products(category)
    category.products.each do |product|
      expect(page).to have_content product.name
      expect(page).to have_content (product.price/100)
      expect(page).to have_css ("img[src$='#{product.image}']") 
    end
  end

  def expect_to_see_sacred_symbol_products(sacred_symbol)
    sacred_symbol.products.each do |product|
      expect(page).to have_content product.name
      expect(page).to have_content (product.price/100)
      expect(page).to have_css ("img[src$='#{product.image}']") 
    end
  end

  def add_product_from_wishlist_to_shopping_bag(product)
    find("a[href='/wishlist']").click
    tr = find('tr', text: product.name)
    tr.click_link("Add To Bag")
  end

  def expect_product_not_to_be_in_wishlist(product)
    find("a[href='/wishlist']").click
    wishlist = find('.shopping-bag-table')
    expect(wishlist).to_not have_content product.name
  end

  def  delete_product_from_wishlist(product)
    find("a[href='/wishlist']").click
    tr = find('tr', text: product.name)
    tr.find('.btn-warning').click
  end

  def expect_product_not_to_be_in_shopping_bag(product)
    click_link "View Bag"
    expect(page).to_not have_content product.name
  end

  def update_qty_of_shopping_bag_product(product, qty)
    shopping_bag = find('.shopping-bag-table')
    tr = shopping_bag.find('tr', text: product.name)
    tr.fill_in "qty", with: qty
    tr.find('.btn-update').click
  end

  def delete_product_from_shopping_bag(product)
    shopping_bag = find('.shopping-bag-table')
    tr = shopping_bag.find('tr', text: product.name)
    tr.find('.btn-warning').click
  end

end