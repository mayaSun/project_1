Fabricator(:product) do 
  name { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.paragraph(2) }
  price { (100..500).to_a.sample }
  stock { (0..500).to_a.sample }
  image {
    ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join("spec/support/uploads/product.jpg")),
      :type => 'image/jpg',
      :filename => File.basename(File.new(Rails.root.join("spec/support/uploads/product.jpg")))
    )
  }
  category {Fabricate(:category)}
end