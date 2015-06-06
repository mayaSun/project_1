class CreateUserShoppingBagItems < ActiveRecord::Migration
  def change
    create_table :user_shopping_bag_items do |t|
      t.integer :product_id
      t.references :position, polymorphic: true, index: true
      t.integer :qty
      t.timestamps
    end
  end
end
