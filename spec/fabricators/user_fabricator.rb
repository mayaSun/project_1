Fabricator(:user) do
  name { Faker::Name.name  }
  email { Faker::Internet.email }
  password { Faker::Internet.password(5, 20) } 
  role {"customer"}
end

Fabricator(:admin, from: :user) do
  role {"admin"}
end

