require 'spec_helper'

describe UserWishlistItem do
  it {should belong_to(:user)}
  it {should belong_to(:product)}
  it {should validate_presence_of(:product)}
  it {should validate_presence_of(:user)}

  it {should respond_to(:name)}
  it {should respond_to(:image)}
  it {should respond_to(:price)}
end