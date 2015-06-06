class Category <ActiveRecord::Base
  include Sluggable
  sluggable_column :name

  has_many :products 
  validates_presence_of :name 

  before_save :capitalize_name

  def capitalize_name
    self.name = self.name.titleize
  end


  def self.search_by_name(search_term)
    return [] if search_term.blank?
    Category.where("name ILIKE ? ", "%#{search_term}%")
  end

end