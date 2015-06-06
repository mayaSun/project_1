require 'spec_helper'

feature 'Admin Add Products' do

  given(:admin) {Fabricate(:admin)}
  background do
    page.set_rack_session(user_id: admin.id)
  end

  scenario "admin add update and delete products" do
    
    brass = Fabricate(:category)
    fimo = Fabricate(:category)
    flower_of_life = Fabricate(:sacred_symbol)
    merkaba = Fabricate(:sacred_symbol)
    
    visit home_path
    # Add Products
    product1 = add_new_product(brass, [flower_of_life.id])
    check_product_pages(product1, brass, [flower_of_life.id])
    product2 = add_new_product(brass, [flower_of_life.id, merkaba.id])
    check_product_pages(product2, brass, [flower_of_life.id, merkaba.id])
    product3 = add_new_product(fimo, [merkaba.id])
    check_product_pages(product3, fimo, [merkaba.id])
    product4 = add_new_product(fimo, [flower_of_life.id, merkaba.id])
    check_product_pages(product4, fimo, [flower_of_life.id, merkaba.id])
    # Updates
    update_product_attribute(product1, 'name', 'Gold Flower Of Life')
    check_product_attribute_and_return_old_value(product1, 'name', 'Gold Flower Of Life')
 
    update_product_attribute(product1, 'description', 'bla bla bla bla')
    check_product_attribute_and_return_old_value(product1, 'description', 'bla bla bla bla')

    update_product_attribute(product1, 'price', '20000')
    check_product_attribute_and_return_old_value(product1, 'price', 20000)
 
    update_product_attribute(product1, 'stock', '70')
    check_product_attribute_and_return_old_value(product1, 'stock', 70)

    test_product_category_update(product1, fimo)
    test_product_sacred_symbols_update(product1, [merkaba.id])
    test_product_image_update(product1)
    # Delete
    delete_product(product1)
    expect(Product.count).to eq(3)
  end

  def add_new_product(category, sacred_symbol_ids)
    product_attr = Fabricate.attributes_for(:product, category: category, sacred_symbol_ids: sacred_symbol_ids)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Products"
    fill_in 'product_name', with: product_attr[:name]
    select category.name , from: "Category:" 
    attach_file "Picture:", "spec/support/uploads/product.jpg"
    fill_in "Price In", with: product_attr[:price]
    fill_in "Qty In Stock:", with: product_attr[:stock]
    sacred_symbol_ids.each do |id|
      check "product_sacred_symbol_ids_#{id}" 
    end
    fill_in "Description:", with: product_attr[:description]
    page.find('#product-form-submit').click
    return Product.last
  end

  def check_product_pages(product, category, sacred_symbols_ids)
    #Check Category Page
    main_menu = page.find('#main-menu')
    main_menu.click_link category.name
    expect(page).to have_content product.name
    expect(page).to have_content (product.price/100)
    expect(page).to have_css ("img[src$='#{product.image}']")
    #Check Sacred Symbol pages
    sacred_symbols_ids.each do |id|
      click_link SacredSymbol.find(id).name
      expect(page).to have_content product.name
      expect(page).to have_content (product.price/100)
      expect(page).to have_css ("img[src$='#{product.image}']")
    end
    #Check Product Page
    click_link product.name
    product_info = page.find('.product-info')
    tabs = page.find('.tabs-panel')
    expect(product_info).to have_content product.name
    expect(product_info).to have_content (product.price/100)
    expect(product_info).to have_css ("img[src$='#{product.image}']")
    expect(tabs).to have_content product.description
    expect(product_info).to have_content category.name
    expect(tabs).to have_content category.name
    expect(tabs).to have_content category.description
    sacred_symbols_ids.each do |id|
      sacred_symbol =  SacredSymbol.find(id)
      expect(product_info).to have_content sacred_symbol.name
      expect(tabs).to have_content sacred_symbol.name
      expect(tabs).to have_content sacred_symbol.description
    end
  end

  def update_product_attribute(product, attribute, value)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Products"
    find("a[href='/admin/products/#{product.slug}/edit']").click
    fill_in "product_#{attribute}", with: value
    page.find('#product-form-submit').click
  end

  def check_product_attribute_and_return_old_value(product, attribute, value)
    product_from_db = Product.find(product.id)
    expect(product_from_db.name).to eq(product.name) unless attribute == 'name'
    expect(product_from_db.description).to eq(product.description) unless attribute == 'description'
    expect(product_from_db.price).to eq(product.price) unless attribute == 'price'   
    expect(product_from_db.stock).to eq(product.stock) unless attribute == 'stock'
    expect(product_from_db.category_id).to eq(product.category_id) unless attribute == 'category_id'
    expect(product_from_db.sacred_symbol_ids).to eq(product.sacred_symbol_ids) unless attribute == 'sacred_symbol_ids'
    
    if attribute
      expect(product_from_db[attribute.to_sym]).to eq(value)
      product_from_db.update_attribute(attribute.to_sym, product[attribute.to_sym])
    end
  end


  def  test_product_category_update(product, category)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Products"
    find("a[href='/admin/products/#{product.slug}/edit']").click
    select category.name , from: "Category:" 
    page.find('#product-form-submit').click
    check_product_attribute_and_return_old_value(product, "category_id", category.id)
  end

  def test_product_sacred_symbols_update(product, sacred_symbol_ids)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Products"
    find("a[href='/admin/products/#{product.slug}/edit']").click
    product.sacred_symbol_ids.each do |id|
      uncheck "product_sacred_symbol_ids_#{id}" 
    end 
    sacred_symbol_ids.each do |id|
      check "product_sacred_symbol_ids_#{id}" 
    end 
    page.find('#product-form-submit').click
    expect(Product.find(product.id).sacred_symbol_ids).to eq(sacred_symbol_ids)
    product.update(sacred_symbol_ids: product.sacred_symbol_ids)
  end
  
  def test_product_image_update(product)
    expect(product.image.url).to eq("/uploads/product.jpg")
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Products"
    find("a[href='/admin/products/#{product.slug}/edit']").click
    attach_file "Picture:", "spec/support/uploads/new_pic.jpg"
    page.find('#product-form-submit').click
    expect(Product.find(product.id).image.url).to eq("/uploads/new_pic.jpg")
  end 

  def delete_product(product)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Products"
    find("a[href='/admin/products/#{product.slug}']").click
  end

end