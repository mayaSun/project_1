require 'spec_helper'

feature 'Admin Add Category' do

  given(:admin) {Fabricate(:admin)}
  background do
    page.set_rack_session(user_id: admin.id)
  end

  scenario "admin add update and delete category" do
    visit home_path
    # Add Categories
    brass = add_new_category()
    check_category_pages(brass)
    fimo = add_new_category()
    check_category_pages(fimo)
    german_silver = add_new_category()
    check_category_pages(german_silver)
    # Update Category
    update_category_attribute(brass, 'name', 'Silver')
    check_category_attribute_and_return_old_value(brass, 'name', 'Silver')
    update_category_attribute(brass, 'description', 'best silver ever')
    check_category_attribute_and_return_old_value(brass, 'description', 'best silver ever')
    # Delete Category
    delete_category(brass)
    expect(Category.count).to eq(2)
    product = Fabricate(:product, category: fimo)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Categories"
    expect(page).to have_content "Category can not be delete if there are product in it"
  end

  def add_new_category
    category_attr = Fabricate.attributes_for(:category)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Categories"
    fill_in 'Name:', with: category_attr[:name]
    fill_in "Description:", with: category_attr[:description]
    page.find('#category-form-submit').click
    return Category.last
  end

  def check_category_pages(category)
    main_menu = page.find('#main-menu')
    main_menu.click_link category.name
    expect(page).to have_content category.name
    expect(page).to have_content category.description
  end

def update_category_attribute(category, attribute, value)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Categories"
    find("a[href='/admin/categories/#{category.slug}/edit']").click
    fill_in "category_#{attribute}", with: value
    page.find('#category-form-submit').click
  end

  def check_category_attribute_and_return_old_value(category, attribute, value)
    category_from_db = Category.find(category.id)
    expect(category_from_db.name).to eq(category.name) unless attribute == 'name'
    expect(category_from_db.description).to eq(category.description) unless attribute == 'description'
    if attribute
      expect(category_from_db[attribute.to_sym]).to eq(value)
      category_from_db.update_attribute(attribute.to_sym, category[attribute.to_sym])
    end
  end

  def delete_category(category)
    click_link "Administration"
    menu = find('.admin-menu').find('.hidden-xs').find('.list-group')
    menu.click_link "Categories"
    find("a[href='/admin/categories/#{category.slug}'][data-method='delete']").click
  end

end