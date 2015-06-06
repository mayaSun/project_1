class Product <ActiveRecord::Base
  include Sluggable
  sluggable_column :name
  
  belongs_to :category
  has_many :product_symbols
  has_many :sacred_symbols, through: :product_symbols
  validates_presence_of :name , :description, :category, :price, :image
  mount_uploader :image, ProductImageUploader
  validates_numericality_of :stock, {only_integer: true, greater_than_or_equal_to: 0}
  validates_numericality_of :price, {only_integer: true, greater_than_or_equal_to: 100}

  has_many :user_shopping_bag_items
 
  has_many :user_wishlist_items
  has_many :wishlisted_users, through: :user_wishlist_items, source: :user

  before_save :capitalize_name

  def capitalize_name
    self.name = self.name.titleize
  end

  def self.search_by_name(search_term)
    return [] if search_term.blank?
    Product.where("name ILIKE ? ", "%#{search_term}%")
  end 

  def last_ordered
    orders.last.updated_at unless orders.empty?
  end

  def orders
    user_shopping_bag_items.where("position_type ILIKE ? ", Order).order('updated_at')
  end

end