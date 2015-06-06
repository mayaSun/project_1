require 'spec_helper'

feature 'Admin Add Sacred Symbol' do

  given(:admin) {Fabricate(:admin)}
  background do
    page.set_rack_session(user_id: admin.id)
  end

  scenario "admin add update and delete sacred symbol" do
    visit home_path
    # Add sacred symbols
    flower_of_life = add_new_sacred_symbol()
    check_sacred_symbol_pages(flower_of_life)
    pentagram = add_new_sacred_symbol()
    check_sacred_symbol_pages(pentagram)
    merkaba = add_new_sacred_symbol()
    check_sacred_symbol_pages(merkaba)
    # Update sacred_symbol
    update_sacred_symbol_attribute(flower_of_life, 'name', 'flawer of life')
    check_sacred_symbol_attribute_and_return_old_value(flower_of_life, 'name', 'Flawer Of Life')
    update_sacred_symbol_attribute(flower_of_life, 'description', 'bla bla bla')
    check_sacred_symbol_attribute_and_return_old_value(flower_of_life, 'description', 'bla bla bla')
    test_sacred_symbol_image_update(flower_of_life)
    # Delete sacred_symbol
    delete_sacred_symbol(flower_of_life)
    expect(SacredSymbol.count).to eq(2)
  end

  def add_new_sacred_symbol
    sacred_symbol_attr = Fabricate.attributes_for(:sacred_symbol)
    click_link "Administration"
    #require pry; binding.pry
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Sacred Symbols"
    fill_in 'Name:', with: sacred_symbol_attr[:name]
    fill_in "Description:", with: sacred_symbol_attr[:description]
    attach_file "Picture:", "spec/support/uploads/sacred_symbol.jpg"
    page.find('#sacred_symbol-form-submit').click
    return SacredSymbol.last
  end

  def check_sacred_symbol_pages(sacred_symbol)
    main_menu = page.find('#main-menu')
    main_menu.click_link sacred_symbol.name
    expect(page).to have_content sacred_symbol.name
    expect(page).to have_content sacred_symbol.description
  end

def update_sacred_symbol_attribute(sacred_symbol, attribute, value)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Sacred Symbols"
    find("a[href='/admin/sacred_symbols/#{sacred_symbol.slug}/edit']").click
    fill_in "sacred_symbol_#{attribute}", with: value
    page.find('#sacred_symbol-form-submit').click
  end

  def check_sacred_symbol_attribute_and_return_old_value(sacred_symbol, attribute, value)
    sacred_symbol_from_db = SacredSymbol.find(sacred_symbol.id)
    expect(sacred_symbol_from_db.name).to eq(sacred_symbol.name) unless attribute == 'name'
    expect(sacred_symbol_from_db.description).to eq(sacred_symbol.description) unless attribute == 'description'
    if attribute
      expect(sacred_symbol_from_db[attribute.to_sym]).to eq(value)
      sacred_symbol_from_db.update_attribute(attribute.to_sym, sacred_symbol[attribute.to_sym])
    end
  end

  def delete_sacred_symbol(sacred_symbol)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Sacred Symbols"
    find("a[href='/admin/sacred_symbols/#{sacred_symbol.slug}'][data-method='delete']").click
  end

  def test_sacred_symbol_image_update(sacred_symbol)
    expect(sacred_symbol.image.url).to eq("/uploads/sacred_symbol.jpg")
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Sacred Symbols"
    find("a[href='/admin/sacred_symbols/#{sacred_symbol.slug}/edit']").click
    attach_file "Picture:", "spec/support/uploads/new_pic.jpg"
    page.find('#sacred_symbol-form-submit').click
    expect(SacredSymbol.find(sacred_symbol.id).image.url).to eq("/uploads/new_pic.jpg")
  end

end