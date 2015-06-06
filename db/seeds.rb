# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.create(name:'Sterling Silver', description: 'Sterling Silver Jewelry description, how pure is the silver, and were its made..')
Category.create(name:'German Silver', description: 'Sterling Silver Jewelry description, how pure is the silver, and were its made..')
Category.create(name:'Brass', description: 'Sterling Silver Jewelry description, how pure is the silver, and were its made..')
Category.create(name:'Fimo', description: 'Sterling Silver Jewelry description, how pure is the silver, and were its made..')


SacredSymbol.create(name: 'Flower Of Life', image: open("public/images/symbols/flower_of_life.jpg"), description: 'Geometrical figure composed of multiple evenly-spaced, overlapping circles, that are arranged so that they form a flower-like pattern with a sixfold symmetry like a hexagon. The center of each circle is on the circumference of six surrounding circles of the same diameter.')
SacredSymbol.create(name: 'Pentagram', image: open("public/images/symbols/pentagram.jpg"), description: 'A five pointed star, encased by an outer circle. Adopted by the first pagan practioners, it is always seen with it\'s apex pointing upward toward the Divine.')
SacredSymbol.create(name: 'Merkaba', image: open("public/images/symbols/merkaba.jpg"), description: 'Merkabah, also spelled Merkaba, is the divine light vehicle allegedly used by ascended masters to connect with and reach those in tune with the higher realms. "Mer" means Light. "Ka" means Spirit. "Ba" means Body. Mer-Ka-Ba means the spirit/body surrounded by counter-rotating fields of light, (wheels within wheels), spirals of energy as in DNA, which transports spirit/body from one dimension to another.')
SacredSymbol.create(name: 'Sri Yantra', image: open("public/images/symbols/sri_yantra.jpg"), description: 'In the Shri Vidya school of Hindu tantra, the Sri Yantra ("sacred instrument", also Sri Chakra) is a diagram formed by nine interlocking triangles that surround and radiate out from the central (bindu) point. It represents the goddess in her form of Shri Lalita Or Tripura Sundari, "the beauty of the three worlds (earth,atmosphere and sky(heaven)"(Bhoo, Bhuva and Swa).[according to whom?] The worship of the Sri Chakra is central to the Shri Vidya system of Hindu worship.')
SacredSymbol.create(name: 'Aum', image: open("public/images/symbols/aum.jpg"), description: 'Om is a sacred syllable of Hinduism. The syllable Om is also referred to as Omkara.')
SacredSymbol.create(name: 'Eye Of Taurus', image: open("public/images/symbols/eye_of_taures.jpg"), description: 'The Eye of Horus is an ancient Egyptian symbol of protection, royal power and good health. The eye is personified in the goddess Wadjet . It is also known as \"The Eye of Ra\"')

Product.create(name: 'Gold Flower Of Life On Blue Background', image: open("public/images/product-images/1.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first, sacred_symbol_ids: [1])
Product.create(name: 'Merkaba With Black Background', image: open("public/images/product-images/2.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first, sacred_symbol_ids: [3])
Product.create(name: 'Gold And Purple Sri Yantra', image: open("public/images/product-images/3.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first, sacred_symbol_ids: [4])
Product.create(name: 'Colorful Flower Of Life With Merkaba', image: open("public/images/product-images/4.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.find(4), sacred_symbol_ids: [1,3])
Product.create(name: 'Happy Colorful Mandala', image: open("public/images/product-images/5.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.find(4))
Product.create(name: 'The Happy Colorfull Cros', image: open("public/images/product-images/6.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.find(4))
Product.create(name: 'Purple Pentagram On Black Backgroung', image: open("public/images/product-images/7.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first, sacred_symbol_ids: [2])
Product.create(name: 'Hamsa For Good Eye', image: open("public/images/product-images/8.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first)
Product.create(name: 'Peace Black And White', image: open("public/images/product-images/9.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first)
Product.create(name: 'The Holly World Circle', image: open("public/images/product-images/10.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first)
Product.create(name: 'The Tow Snacks Of Medicine', image: open("public/images/product-images/11.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first)
Product.create(name: 'Gold Flower Rainbow Ring', image: open("public/images/product-images/12.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first)
Product.create(name: 'Silver Aum On Red Backgroung', image: open("public/images/product-images/13.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first, sacred_symbol_ids: [5])
Product.create(name: 'The Red Body On Blue Backgroung', image: open("public/images/product-images/14.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first)
Product.create(name: 'Merkaba Riding A Flower Of Life', image: open("public/images/product-images/15.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first, sacred_symbol_ids: [1,3])
Product.create(name: 'Colorfull Sri Yantra', image: open("public/images/product-images/16.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first, sacred_symbol_ids: [4])
Product.create(name: 'Gold Flower Of Life', image: open("public/images/product-images/17.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first, sacred_symbol_ids: [1])
Product.create(name: 'Very Nice Colorfull Mandala', image: open("public/images/product-images/18.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first)
Product.create(name: 'Waves Are comming In', image: open("public/images/product-images/19.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.first)
Product.create(name: 'The Life Of The Flower Of Life', image: open("public/images/product-images/20.jpg") , description: "German silver pendant, with flower of life 3cm diamete", price:2000, stock: 7, category: Category.find(4), sacred_symbol_ids: [1])

User.create(name: 'Web Owner', email: 'kalidas33@hotmail.com', password: 'admin', role: 'shop_owner')
User.create(name: 'Web Builder', email: 'maya166@gmail.com', password: 'admin', role: 'shop_owner')
User.create(name: 'Example User', email: 'user@example.com', password: 'password')

Order.create(first_name: 'Neal', last_name: 'Yaung', address_line1: 'Flowers Valey 111', city: 'Violina', country_code: 'US', state_code: 'California', postal_code:'1234', phone_number:'123456789', email: 'neal@yaung.com', user: User.find_by(email: 'user@example.com'),reference_id: '123', status: 'paid')
Order.create(first_name: 'Bibi', last_name: 'Netanyaho', address_line1: 'Flowers Hills 111', city: 'Kiopa', country_code: 'US', state_code: 'NY', postal_code:'1234', phone_number:'123456789', email: 'bibi@Netanyaho.com', user: User.find_by(email: 'user@example.com'),reference_id: '123', status: 'paid')
Order.create(first_name: 'Shimon', last_name: 'Peres', address_line1: 'Shimon Hills 111', city: 'Mopaj', country_code: 'US', state_code: 'New Jerjy', postal_code:'1234', phone_number:'123456789', email: 'shimon@peres.com', user: User.find_by(email: 'user@example.com'),reference_id: '123', status: 'paid')

UserShoppingBagItem.create(position: Order.first, product: Product.first, qty: 7)
UserShoppingBagItem.create(position: Order.first, product: Product.find(2), qty: 3)
UserShoppingBagItem.create(position: Order.first, product: Product.find(3), qty: 3)

UserShoppingBagItem.create(position: Order.find(2), product: Product.first, qty: 5)
UserShoppingBagItem.create(position: Order.find(2), product: Product.find(2), qty: 1)
UserShoppingBagItem.create(position: Order.find(2), product: Product.find(4), qty: 3)

UserShoppingBagItem.create(position: Order.find(3), product: Product.find(5), qty: 1)