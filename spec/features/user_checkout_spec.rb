require 'spec_helper'

feature 'User Checkout Spec' do

  given!(:flower_of_life_pendant) { Fabricate(:product, price: 2000, stock: 70) }
  given!(:merkaba_pendant) { Fabricate(:product, price: 3050, stock: 7) }
  given(:order_attr) { Fabricate.attributes_for(:order) } 

  context 'login user' do

    given(:user) { Fabricate(:user)}

    background do
      sign_in(user)
    end

    scenario "user fill order details", js: true do
      visit home_path
      user_fill_shopping_bag
      check_order_details_fill
    end

    scenario "user checkout successfuly", js: true, vcr: true do
      visit home_path
      user_fill_shopping_bag
      user_fill_order_details
      fill_payment_form('4242424242424242')
      click_button "Submit Payment"  
      sleep 20
      expect(page).to have_content 'Payment was made.'
      expect(Order.count).to eq(1)
    end

    scenario "user checkout with invalid card", js: true, vcr: true do
      visit home_path
      user_fill_shopping_bag
      user_fill_order_details
      fill_payment_form('4242424242424240')
      click_button "Submit Payment"  
      sleep 20
      expect(page).to have_content 'Your card number is incorrect'
      expect(Order.count).to eq(0)
    end

    scenario "user checkout with decline card", js: true, vcr: true do
      visit home_path
      user_fill_shopping_bag
      user_fill_order_details
      fill_payment_form('4000000000000002')
      click_button "Submit Payment"  
      sleep 20
      expect(page).to have_content 'Your card was declined.'
      expect(Order.count).to eq(0)
    end

    scenario "user checkout with item that is out of stock", js: true do

    end
  end

  context 'guest user' do

    scenario "user fill order details", js: true do
      visit home_path
      user_fill_shopping_bag
      check_order_details_fill
    end

    scenario "user checkout successfuly", js: true, vcr: true do
      visit home_path
      user_fill_shopping_bag
      user_fill_order_details
      fill_payment_form('4242424242424242')
      click_button "Submit Payment"  
      sleep 20
      expect(page).to have_content 'Payment was made.'
      expect(Order.count).to eq(1)
    end

    scenario "user checkout with invalid card", js: true, vcr: true do
      visit home_path
      user_fill_shopping_bag
      user_fill_order_details
      fill_payment_form('4242424242424240')
      click_button "Submit Payment"  
      sleep 20
      expect(page).to have_content 'Your card number is incorrect'
      expect(Order.count).to eq(0)
    end

    scenario "user checkout with decline card", js: true, vcr: true do
      visit home_path
      user_fill_shopping_bag
      user_fill_order_details
      fill_payment_form('4000000000000002')
      click_button "Submit Payment"  
      sleep 20
      expect(page).to have_content 'Your card was declined.'
      expect(Order.count).to eq(0)
    end

    scenario "user checkout with item that is out of stock" do

    end
  end

  def user_fill_shopping_bag
    add_product_from_product_page_to_shopping_bag(flower_of_life_pendant, 5)
    add_product_from_product_page_to_shopping_bag(merkaba_pendant, 3)
  end

  def add_product_from_product_page_to_shopping_bag(product, qty=1)
    find(:xpath, "(//a[@href='/products/#{product.slug}'])[1]").click
    form = find('.product-info')
    fill_in "QTY", with: qty
    form.click_button("Add To Bag")
  end

  def check_order_details_fill
    menu = find('.header-links')
    menu.click_link "Checkout"
    # Check the shopping bag details
    expect(page).to have_content flower_of_life_pendant.name
    expect(page).to have_content merkaba_pendant.name
    expect(page).to have_content '5' # QTY
    expect(page).to have_content '3' # QTY
    expect(page).to have_content display_price(flower_of_life_pendant.price*5)
    expect(page).to have_content display_price(merkaba_pendant.price*3)
    expect(page).to have_content display_price(flower_of_life_pendant.price*5 + merkaba_pendant.price*3)
    # Check the country province code
    form = find('#new_order')
    expect(form).to have_content 'Please select a country above'
    form.select 'United States' , from: '*Country:', match: :first
    expect(form).to have_content 'California'
    form.select 'California' , from: 'State/Province:'
    form.click_button 'Submit Payment'
    expect(form).to have_content 'California'
    form.select 'Germany' , from: '*Country:'
    expect(form).not_to have_content 'California'
    form.click_button 'Submit Payment'
    form.fill_in 'State/Province:', with: 'South'
    #Check details save
    form.fill_in '*First Name:', with: 'Neil'
    form.fill_in '*Last Name:', with: 'Young'
    form.fill_in '*Address:', with: 'King Gourge 22'
    form.fill_in 'Line 2:', with: '34/89'
    form.fill_in '*Postal code:', with: '2345'
    form.fill_in '*Phone:', with: '987654321'
    form.fill_in '*E-mail:', with: 'neil@young.com'
    form.click_button 'Submit Payment'
    form.fill_in '*City:', with: 'Tel Aviv'
    form.click_button 'Submit Payment'
    expect(form.find_field('order_first_name').value).to eq 'Neil'
    expect(form.find_field('order_last_name').value).to eq 'Young'
    expect(form.find_field('order_address_line1').value).to eq 'King Gourge 22'
    expect(form.find_field('order_address_line2').value).to eq '34/89'
    expect(form.find_field('order_postal_code').value).to eq '2345'
    expect(form.find_field('order_country_code').value).to eq 'DE'
    expect(form.find_field('order_state_code').value).to eq 'South'
    expect(form.find_field('order_phone_number').value).to eq '987654321'
    expect(form.find_field('order_email').value).to eq 'neil@young.com'
    expect(form.find_field('order_city').value).to eq 'Tel Aviv'
    form.check 'accept_terms_and_conditions'
    form.click_button 'Submit Payment'
    expect(current_path).to eq(payment_path)  
  end

  def user_fill_order_details
    menu = find('.header-links')
    menu.click_link "Checkout"
    form = find('#new_order')
    form.fill_in '*First Name:', with: order_attr[:first_name]
    form.fill_in '*Last Name:', with: order_attr[:last_name]
    form.fill_in '*Address:', with: order_attr[:address_line1]
    form.fill_in '*Postal code:', with: order_attr[:postal_code]
    form.fill_in '*City:', with: order_attr[:city]
    form.fill_in '*Phone:', with: order_attr[:phone_number]
    form.fill_in '*E-mail:', with: order_attr[:email]
    form.select 'Germany' , from: '*Country:'
    form.check 'accept_terms_and_conditions'
    form.click_button 'Submit Payment'
    expect(current_path).to eq(payment_path)
  end

  def fill_payment_form(card_number)
    fill_in "Credit Card Number", with: card_number
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2019", from: "date_year"
  end

end

