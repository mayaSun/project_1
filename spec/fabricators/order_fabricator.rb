Fabricator(:order) do
  first_name { Faker::Name.name  }
  last_name { Faker::Name.name  }
  email { Faker::Internet.email }
  address_line1 { Faker::Address.street_address }
  address_line2 { Faker::Address.secondary_address }
  city { Faker::Address.city }
  country_code { Faker::Address.state }
  state_code { Faker::Address.state_abbr }
  postal_code { Faker::Address.zip_code }
  phone_number { Faker::PhoneNumber.phone_number }
  email { Faker::Internet.email }
 end