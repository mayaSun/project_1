class User <ActiveRecord::Base
  include Sluggable
  sluggable_column :name
  
  has_secure_password validations: false
  validates_presence_of :email 
  validates_uniqueness_of :email 
  after_validation :set_user_name
  validates_confirmation_of :password
  validates :password, presence: true, on: :create, length: {minimum: 5}

  has_many :user_shopping_bag_items, as: :position
  has_many :shopping_bag_items, through: :user_shopping_bag_items, source: :product

  has_many :user_wishlist_items
  has_many :wishlist_items, through: :user_wishlist_items, source: :product

  has_many :orders

  def set_user_name
    if !self.name || self.name.length < 2
      if self.email
        self.name = self.email.split("@").first
      end   
    end     
  end

  def total_bill(user=nil)
    user_shopping_bag_items.map(&:total_price).inject(0, :+)    
  end
end