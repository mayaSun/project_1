Fabricator(:sacred_symbol) do 
  name { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.paragraph(2) }
  image {
    ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join("spec/support/uploads/product.jpg")),
      :type => 'image/jpg',
      :filename => File.basename(File.new(Rails.root.join("spec/support/uploads/product.jpg")))
    )
  }

end