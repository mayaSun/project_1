require 'spec_helper'

feature "User Signin" do

  given(:shop_owner) { Fabricate(:user, role: 'shop_owner') }
  given(:user_attr) { Fabricate.attributes_for(:user) }

  scenario "user sign up than shop owner make him admin", js: true do
    user = user_sign_up
    check_user_pages(user, user_attr[:password])
    click_link "LogOut"
    sign_in(shop_owner)
    change_user_to_admin(user)
    click_link "LogOut"
    sign_in(user, user_attr[:password])
    expect(page).to have_content "Administration"
  end

  def user_sign_up
    visit home_path
    click_link "Sign Up" 
    fill_in "User Name:", with: user_attr[:name]
    fill_in "Email Address:", with: user_attr[:email]
    fill_in 'user_password', with: user_attr[:password]
    fill_in "Confirm Password:", with: user_attr[:password]
    click_button "Sign Up"
    sleep 1
    return User.last
  end

  def check_user_pages(user,password)
    click_link "My Account"
    fill_in "User Name:", with: "Shalom"
    fill_in "Email Address:", with: "shalom@gmail.com"
    fill_in 'data_authentication', with: password
    click_button "Update"
    sleep 1
    side_menu = find('.list-group')
    side_menu.click_link "My Account"
    fill_in 'password_authentication', with: password
    fill_in "*New Password:", with: "shalomiel"
    fill_in "Confirm:", with: "shalomiel"
    click_button "Reset Password"
    sleep 1
    user_from_db = User.find(user.id)
    expect(user_from_db.name).to eq("Shalom")
    expect(user_from_db.email).to eq("shalom@gmail.com")
    expect(user_from_db.authenticate("shalomiel")).to_not be(false)
    User.find(user.id).update(name: user.name, email: user.email, password: password)
  end

  def change_user_to_admin(user)
    click_link "Administration"
    menu = find('.admin-menu')
    menu.find('.navbar-toggle').click
    menu.click_link "Users"
    users_table = find('.admin-table')
    tr = users_table.find('tr', text: user.name)
    expect(tr).to have_content (user.email)
    expect(tr).to have_content (user.orders.count)
    tr.select 'admin' , from: 'role'
    tr.click_button "Update"
    sleep 1
    expect(User.find(user.id).role).to eq('admin')
  end

end