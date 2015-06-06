class SacredSymbol <ActiveRecord::Base
  include Sluggable
  sluggable_column :name
  
  has_many :product_symbols
  has_many :products, through: :product_symbols
  validates_presence_of :name , :image, :description
  mount_uploader :image, SacredSymbolImageUploader

  before_save :capitalize_name

  def capitalize_name
    self.name = self.name.titleize
  end

  def self.search_by_name(search_term)
    return [] if search_term.blank?
    SacredSymbol.where("name ILIKE ? ", "%#{search_term}%")
  end 
end