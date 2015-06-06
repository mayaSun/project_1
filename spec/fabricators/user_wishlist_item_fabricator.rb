Fabricator(:user_wishlist_item) do
  user {Fabricate(:user)}
  product {Fabricate(:product)}
end