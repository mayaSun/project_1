Fabricator(:user_shopping_bag_item) do
  position {Fabricate(:user)}
  product {Fabricate(:product)}
  qty {(1..50).to_a.sample}
end