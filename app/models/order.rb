class Order <ActiveRecord::Base
  include Sluggable
  sluggable_column :slug_column

  validates_presence_of :first_name , :last_name, :address_line1, :city, :country_code, :phone_number, :postal_code, :email  
  has_many :user_shopping_bag_items, as: :position
  has_many :shopping_bag_items, through: :user_shopping_bag_items, source: :product
  belongs_to :user

  def slug_column
    first_name + last_name
  end

  def total_bill
    user_shopping_bag_items.map(&:total_price).inject(0, :+)
  end

  def update_stock
    user_shopping_bag_items.each do |shopping_bag_item|
      shopping_bag_item.product.update(stock: shopping_bag_item.product.stock - shopping_bag_item.qty)
    end
  end

  def self.last_orders
    Order.where("status LIKE ? ", 'paid%').order('updated_at') + Order.where("status LIKE ? ", 'sent').order('updated_at DESC')
  end

  def paypal_url(return_path)
    values = {
        business: "maya166-facilitator@gmail.com",
        cmd: "_xclick",
        upload: 1,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        invoice: id,
        amount: 10000,
        item_name: "maya",
        item_number: 1,
        quantity: '1',
        notify_url: "#{Rails.application.secrets.app_host}/paypal_hook"
    }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end
end